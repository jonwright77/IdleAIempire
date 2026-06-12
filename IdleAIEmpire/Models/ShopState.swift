import Foundation

struct ShopState: Codable {
    var permanentBoostCount: Int
    var boostEndDate: Date?

    init() {
        permanentBoostCount = 0
        boostEndDate = nil
    }

    var isTimedBoostActive: Bool {
        guard let end = boostEndDate else { return false }
        return end > Date()
    }

    var remainingBoostSeconds: TimeInterval {
        guard let end = boostEndDate else { return 0 }
        return max(0, end.timeIntervalSinceNow)
    }

    // True as long as remaining time is under the 10-hour cap.
    var canAddTimedBoost: Bool { remainingBoostSeconds < 10 * 3600 }

    var nextPermanentBoostCost: Int { 1000 * Int(pow(2.0, Double(permanentBoostCount))) }

    var permanentMultiplier: Double { pow(2.0, Double(permanentBoostCount)) }
    var timedMultiplier: Double { isTimedBoostActive ? 2.0 : 1.0 }
    var totalMultiplier: Double { permanentMultiplier * timedMultiplier }
}
