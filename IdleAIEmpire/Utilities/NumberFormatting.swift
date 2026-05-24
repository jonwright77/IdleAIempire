import Foundation

extension Double {
    /// Short display string: "42.3K", "1.50M", "3.14Sp", etc.
    var compactFormatted: String {
        let a = abs(self)
        switch a {
        case 0..<1_000:              return String(format: "%.1f", self)
        case 1e3..<1e6:              return String(format: "%.2fK",  self / 1e3)
        case 1e6..<1e9:              return String(format: "%.2fM",  self / 1e6)
        case 1e9..<1e12:             return String(format: "%.2fB",  self / 1e9)
        case 1e12..<1e15:            return String(format: "%.2fT",  self / 1e12)
        case 1e15..<1e18:            return String(format: "%.2fQ",  self / 1e15)
        case 1e18..<1e21:            return String(format: "%.2fQi", self / 1e18)
        case 1e21..<1e24:            return String(format: "%.2fSx", self / 1e21)
        case 1e24..<1e27:            return String(format: "%.2fSp", self / 1e24)
        case 1e27..<1e30:            return String(format: "%.2fOc", self / 1e27)
        case 1e30..<1e33:            return String(format: "%.2fNo", self / 1e30)
        default:                     return String(format: "%.2fDc", self / 1e33)
        }
    }
}
