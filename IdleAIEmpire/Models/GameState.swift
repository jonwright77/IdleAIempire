import Foundation

struct GameState: Codable {
    var compute: Double
    var computePerTap: Double
    var upgrades: [Upgrade]
    var researchNodes: [ResearchNode]
    var lastSaveDate: Date

    init() {
        compute = 0
        computePerTap = 1
        upgrades = Upgrade.catalog
        researchNodes = ResearchNode.catalog
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

    // Offline cap starts at 3h; Edge Compute adds 5h.
    var offlineCap: TimeInterval {
        let bonusHours = unlockedNodes.reduce(0.0) { $0 + $1.offlineHoursBonus }
        return (3 + bonusHours) * 3600
    }

    // MARK: - Effective values (used by gameplay)

    var effectiveComputePerSecond: Double { computePerSecond * effectiveCPSMultiplier }
    var effectiveComputePerTap: Double { computePerTap * effectiveTapMultiplier }

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
}
