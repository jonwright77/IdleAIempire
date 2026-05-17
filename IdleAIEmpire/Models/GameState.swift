import Foundation

struct GameState: Codable {
    var compute: Double
    var computePerTap: Double
    var upgrades: [Upgrade]
    var lastSaveDate: Date

    init() {
        compute = 0
        computePerTap = 1
        upgrades = Upgrade.catalog
        lastSaveDate = Date()
    }

    var computePerSecond: Double {
        upgrades.reduce(0) { $0 + $1.computePerSecond }
    }
}
