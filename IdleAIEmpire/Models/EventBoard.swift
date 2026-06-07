import Foundation

struct EventBoard: Codable, Identifiable {
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
    var gemMilestonesEarned: Set<String>

    init(definition: EventDefinition, unlocked: Bool) {
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
        self.gemMilestonesEarned = []
    }

    // MARK: - Codable (safe decoding for future schema changes)

    private enum CodingKeys: String, CodingKey {
        case id, unlocked, compute, computePerTap, upgrades, researchNodes
        case singularityShards, singularityPoints, singularityUpgradeLevels
        case lastSaveDate, gemMilestonesEarned
    }

    init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        id                       = try c.decode(String.self,        forKey: .id)
        unlocked                 = try c.decode(Bool.self,          forKey: .unlocked)
        compute                  = (try? c.decode(Double.self,         forKey: .compute))                  ?? 0
        computePerTap            = (try? c.decode(Double.self,         forKey: .computePerTap))            ?? 1
        upgrades                 = (try? c.decode([Upgrade].self,      forKey: .upgrades))                 ?? []
        researchNodes            = (try? c.decode([ResearchNode].self, forKey: .researchNodes))            ?? []
        singularityShards        = (try? c.decode(Int.self,            forKey: .singularityShards))        ?? 0
        singularityPoints        = (try? c.decode(Int.self,            forKey: .singularityPoints))        ?? 0
        singularityUpgradeLevels = (try? c.decode([String: Int].self, forKey: .singularityUpgradeLevels)) ?? [:]
        lastSaveDate             = (try? c.decode(Date.self,           forKey: .lastSaveDate))             ?? Date()
        gemMilestonesEarned      = (try? c.decode(Set<String>.self,    forKey: .gemMilestonesEarned))     ?? []
    }

    func encode(to encoder: Encoder) throws {
        var c = encoder.container(keyedBy: CodingKeys.self)
        try c.encode(id,                       forKey: .id)
        try c.encode(unlocked,                 forKey: .unlocked)
        try c.encode(compute,                  forKey: .compute)
        try c.encode(computePerTap,            forKey: .computePerTap)
        try c.encode(upgrades,                 forKey: .upgrades)
        try c.encode(researchNodes,            forKey: .researchNodes)
        try c.encode(singularityShards,        forKey: .singularityShards)
        try c.encode(singularityPoints,        forKey: .singularityPoints)
        try c.encode(singularityUpgradeLevels, forKey: .singularityUpgradeLevels)
        try c.encode(lastSaveDate,             forKey: .lastSaveDate)
        try c.encode(gemMilestonesEarned,      forKey: .gemMilestonesEarned)
    }

    // MARK: - Computed values (mirrors PlanetBoard, but shard multiplier uses base 1.5)

    var computePerSecond: Double {
        upgrades.reduce(0) { sum, upgrade in
            let level = singularityUpgradeLevels[upgrade.id] ?? 0
            return sum + upgrade.computePerSecond * Upgrade.singularityMultiplier(forLevel: level)
        }
    }

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

    // Events use 1.5 base — each shard is dramatically more powerful than the planet 1.1 base.
    var shardMultiplier: Double { pow(1.5, Double(singularityShards)) }

    var effectiveComputePerSecond: Double {
        computePerSecond * effectiveCPSMultiplier * shardMultiplier
    }

    var effectiveComputePerTap: Double {
        computePerTap * effectiveTapMultiplier * shardMultiplier
    }

    var isAutoTapping: Bool {
        (upgrades.first?.owned ?? 0) >= 25
    }

    // MARK: - Merge helpers (same pattern as PlanetBoard)

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
