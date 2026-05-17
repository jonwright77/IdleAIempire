import Foundation

extension Double {
    /// Short display string: "42.3K", "1.50M", etc.
    var compactFormatted: String {
        switch abs(self) {
        case 0..<1_000:
            return String(format: "%.1f", self)
        case 1_000..<1_000_000:
            return String(format: "%.2fK", self / 1_000)
        case 1_000_000..<1_000_000_000:
            return String(format: "%.2fM", self / 1_000_000)
        case 1_000_000_000..<1_000_000_000_000:
            return String(format: "%.2fB", self / 1_000_000_000)
        default:
            return String(format: "%.2fT", self / 1_000_000_000_000)
        }
    }
}
