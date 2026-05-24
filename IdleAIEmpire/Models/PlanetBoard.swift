import Foundation

struct PlanetBoard: Codable, Identifiable {
    let id: String
    var unlocked: Bool
    var compute: Double
    var computePerTap: Double
    var upgrades: [Upgrade]
    var researchNodes: [ResearchNode]
    var singularityShards: Int
    var singularityPoints: Int
    var singularityUpgradeLevels: [String: Int]
    var lastSaveDate: Date

    init(definition: PlanetDefinition, unlocked: Bool) {
        self.id = definition.id
        self.unlocked = unlocked
        self.compute = 0
        self.computePerTap = 1
        self.upgrades = definition.upgradeCatalog
        self.researchNodes = definition.researchCatalog
        self.singularityShards = 0
        self.singularityPoints = 0
        self.singularityUpgradeLevels = [:]
        self.lastSaveDate = Date()
    }

    // MARK: - Base values

    var computePerSecond: Double {
        upgrades.reduce(0) { sum, upgrade in
            let level = singularityUpgradeLevels[upgrade.id] ?? 0
            return sum + upgrade.computePerSecond * Upgrade.singularityMultiplier(forLevel: level)
        }
    }

    // MARK: - Research multipliers

    private var unlockedNodes: [ResearchNode] { researchNodes.filter { $0.unlocked } }

    var effectiveCPSMultiplier: Double {
        unlockedNodes.reduce(1.0) { $0 * $1.cpsMultiplier }
    }

    var effectiveTapMultiplier: Double {
        unlockedNodes.reduce(1.0) { $0 * $1.tapMultiplier }
    }

    var offlineCap: TimeInterval {
        let bonusHours = unlockedNodes.reduce(0.0) { $0 + $1.offlineHoursBonus }
        return (3 + bonusHours) * 3600
    }

    // MARK: - Prestige

    var shardMultiplier: Double { pow(1.1, Double(singularityShards)) }

    // MARK: - Effective values

    var effectiveComputePerSecond: Double {
        computePerSecond * effectiveCPSMultiplier * shardMultiplier
    }

    var effectiveComputePerTap: Double {
        computePerTap * effectiveTapMultiplier * shardMultiplier
    }

    var isAutoTapping: Bool {
        (upgrades.first?.owned ?? 0) >= 25
    }

    // MARK: - Save migration helpers

    mutating func mergeUpgrades(catalog: [Upgrade]) {
        for i in upgrades.indices where i < catalog.count {
            let owned = upgrades[i].owned
            upgrades[i] = catalog[i]
            upgrades[i].owned = owned
        }
        if upgrades.count < catalog.count {
            upgrades.append(contentsOf: catalog[upgrades.count...])
        }
    }

    mutating func mergeResearch(catalog: [ResearchNode]) {
        for i in researchNodes.indices where i < catalog.count {
            let wasUnlocked = researchNodes[i].unlocked
            researchNodes[i] = catalog[i]
            researchNodes[i].unlocked = wasUnlocked
        }
        if researchNodes.count < catalog.count {
            researchNodes.append(contentsOf: catalog[researchNodes.count...])
        }
    }
}
