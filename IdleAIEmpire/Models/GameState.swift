import Foundation

struct GameState: Codable {
    var compute: Double
    var computePerTap: Double
    var upgrades: [Upgrade]
    var researchNodes: [ResearchNode]
    var singularityShards: Int
    var achievements: [Achievement]
    var lastSaveDate: Date

    init() {
        compute = 0
        computePerTap = 1
        upgrades = Upgrade.catalog
        researchNodes = ResearchNode.catalog
        singularityShards = 0
        achievements = Achievement.catalog
        lastSaveDate = Date()
    }

    // MARK: - Base values (from upgrades only)

    var computePerSecond: Double {
        upgrades.reduce(0) { $0 + $1.computePerSecond }
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
        guard researchNodes.count < catalog.count else { return }
        researchNodes.append(contentsOf: catalog[researchNodes.count...])
    }

    mutating func mergeNewAchievements() {
        let catalog = Achievement.catalog
        guard achievements.count < catalog.count else { return }
        achievements.append(contentsOf: catalog[achievements.count...])
    }
}
