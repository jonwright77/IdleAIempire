import Foundation

struct GameState: Codable {
    var planets: [PlanetBoard]
    var activePlanetIndex: Int
    var achievements: [Achievement]

    init() {
        planets = PlanetDefinition.all.enumerated().map { i, def in
            PlanetBoard(definition: def, unlocked: i == 0)
        }
        activePlanetIndex = 0
        achievements = Achievement.catalog
    }

    // MARK: - Coding keys

    private enum CodingKeys: String, CodingKey {
        case planets, activePlanetIndex, achievements
    }

    // Legacy keys present in pre-planet saves.
    private enum LegacyKeys: String, CodingKey {
        case compute, computePerTap, upgrades, researchNodes
        case singularityShards, singularityPoints, singularityUpgradeLevels
        case achievements, lastSaveDate
    }

    init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)

        if let savedPlanets = try? c.decode([PlanetBoard].self, forKey: .planets) {
            // Current save format.
            planets = savedPlanets
            activePlanetIndex = (try? c.decode(Int.self, forKey: .activePlanetIndex)) ?? 0
            achievements = (try? c.decode([Achievement].self, forKey: .achievements)) ?? Achievement.catalog
        } else {
            // Old flat save — migrate Neptune's data into planets[0].
            let legacy = try decoder.container(keyedBy: LegacyKeys.self)
            let compute          = (try? legacy.decode(Double.self,           forKey: .compute))                     ?? 0
            let computePerTap    = (try? legacy.decode(Double.self,           forKey: .computePerTap))               ?? 1
            let upgrades         = (try? legacy.decode([Upgrade].self,        forKey: .upgrades))                    ?? Upgrade.catalog
            let researchNodes    = (try? legacy.decode([ResearchNode].self,   forKey: .researchNodes))               ?? ResearchNode.catalog
            let shards           = (try? legacy.decode(Int.self,              forKey: .singularityShards))           ?? 0
            let points           = (try? legacy.decode(Int.self,              forKey: .singularityPoints))           ?? 0
            let upgradeLevels    = (try? legacy.decode([String: Int].self,    forKey: .singularityUpgradeLevels))    ?? [:]
            let lastSave         = (try? legacy.decode(Date.self,             forKey: .lastSaveDate))                ?? Date()
            let savedAchievements = (try? legacy.decode([Achievement].self,   forKey: .achievements))                ?? Achievement.catalog

            var neptune = PlanetBoard(definition: PlanetDefinition.neptune, unlocked: true)
            neptune.compute = compute
            neptune.computePerTap = computePerTap
            neptune.upgrades = upgrades
            neptune.researchNodes = researchNodes
            neptune.singularityShards = shards
            neptune.singularityPoints = points
            neptune.singularityUpgradeLevels = upgradeLevels
            neptune.lastSaveDate = lastSave

            var allPlanets = PlanetDefinition.all.enumerated().map { i, def in
                PlanetBoard(definition: def, unlocked: i == 0)
            }
            allPlanets[0] = neptune

            planets = allPlanets
            activePlanetIndex = 0
            achievements = savedAchievements
        }
    }

    func encode(to encoder: Encoder) throws {
        var c = encoder.container(keyedBy: CodingKeys.self)
        try c.encode(planets, forKey: .planets)
        try c.encode(activePlanetIndex, forKey: .activePlanetIndex)
        try c.encode(achievements, forKey: .achievements)
    }

    // MARK: - Merge on load (apply any catalog changes to saved data)

    mutating func mergeAll() {
        let defs = PlanetDefinition.all
        // Add any new planets introduced since this save was written.
        if planets.count < defs.count {
            planets.append(contentsOf: defs[planets.count...].enumerated().map { i, def in
                PlanetBoard(definition: def, unlocked: false)
            })
        }
        // Refresh catalog fields (e.g. rebalanced costs) on every saved planet.
        for i in planets.indices where i < defs.count {
            planets[i].mergeUpgrades(catalog: defs[i].upgradeCatalog)
            planets[i].mergeResearch(catalog: defs[i].researchCatalog)
        }
        // Clamp activePlanetIndex in case catalog shrank somehow.
        activePlanetIndex = max(0, min(activePlanetIndex, planets.count - 1))
    }

    mutating func mergeNewAchievements() {
        let catalog = Achievement.catalog
        guard achievements.count < catalog.count else { return }
        achievements.append(contentsOf: catalog[achievements.count...])
    }
}
