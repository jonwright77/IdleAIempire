import Foundation

struct GameState: Codable {
    var compute: Double
    var computePerTap: Double
    var upgrades: [Upgrade]
    var researchNodes: [ResearchNode]
    var singularityShards: Int
    var singularityPoints: Int
    var singularityUpgradeLevels: [String: Int]
    var achievements: [Achievement]
    var lastSaveDate: Date

    init() {
        compute = 0
        computePerTap = 1
        upgrades = Upgrade.catalog
        researchNodes = ResearchNode.catalog
        singularityShards = 0
        singularityPoints = 0
        singularityUpgradeLevels = [:]
        achievements = Achievement.catalog
        lastSaveDate = Date()
    }

    // Backwards-compatible decoder: new fields default gracefully on old saves.
    private enum CodingKeys: String, CodingKey {
        case compute, computePerTap, upgrades, researchNodes
        case singularityShards, singularityPoints, singularityUpgradeLevels
        case achievements, lastSaveDate
    }

    init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        compute = try c.decode(Double.self, forKey: .compute)
        computePerTap = try c.decode(Double.self, forKey: .computePerTap)
        upgrades = try c.decode([Upgrade].self, forKey: .upgrades)
        researchNodes = try c.decode([ResearchNode].self, forKey: .researchNodes)
        singularityShards = try c.decode(Int.self, forKey: .singularityShards)
        singularityPoints = (try? c.decode(Int.self, forKey: .singularityPoints)) ?? 0
        singularityUpgradeLevels = (try? c.decode([String: Int].self, forKey: .singularityUpgradeLevels)) ?? [:]
        achievements = try c.decode([Achievement].self, forKey: .achievements)
        lastSaveDate = try c.decode(Date.self, forKey: .lastSaveDate)
    }

    func encode(to encoder: Encoder) throws {
        var c = encoder.container(keyedBy: CodingKeys.self)
        try c.encode(compute, forKey: .compute)
        try c.encode(computePerTap, forKey: .computePerTap)
        try c.encode(upgrades, forKey: .upgrades)
        try c.encode(researchNodes, forKey: .researchNodes)
        try c.encode(singularityShards, forKey: .singularityShards)
        try c.encode(singularityPoints, forKey: .singularityPoints)
        try c.encode(singularityUpgradeLevels, forKey: .singularityUpgradeLevels)
        try c.encode(achievements, forKey: .achievements)
        try c.encode(lastSaveDate, forKey: .lastSaveDate)
    }

    // MARK: - Base values (from upgrades + singularity bonuses)

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

    // MARK: - Prestige (Singularity)

    // ×1.1 per shard, stacking multiplicatively.
    var shardMultiplier: Double { pow(1.1, Double(singularityShards)) }

    var canPrestige: Bool { compute >= 1_000_000_000_000 }

    // MARK: - Effective values (research + shards combined)

    var effectiveComputePerSecond: Double {
        computePerSecond * effectiveCPSMultiplier * shardMultiplier
    }

    var effectiveComputePerTap: Double {
        computePerTap * effectiveTapMultiplier * shardMultiplier
    }

    // Unlocked permanently once the player owns 25 GPUs.
    var isAutoTapping: Bool {
        (upgrades.first { $0.id == "gpu" }?.owned ?? 0) >= 25
    }

    // MARK: - Save migration

    mutating func mergeNewCatalogEntries() {
        let catalog = Upgrade.catalog
        guard upgrades.count < catalog.count else { return }
        upgrades.append(contentsOf: catalog[upgrades.count...])
    }

    mutating func mergeNewResearchNodes() {
        let catalog = ResearchNode.catalog
        // Refresh catalog-defined fields on existing nodes so balance changes take effect on old saves.
        for i in researchNodes.indices where i < catalog.count {
            var updated = catalog[i]
            updated.unlocked = researchNodes[i].unlocked
            researchNodes[i] = updated
        }
        if researchNodes.count < catalog.count {
            researchNodes.append(contentsOf: catalog[researchNodes.count...])
        }
    }

    mutating func mergeNewAchievements() {
        let catalog = Achievement.catalog
        guard achievements.count < catalog.count else { return }
        achievements.append(contentsOf: catalog[achievements.count...])
    }
}
