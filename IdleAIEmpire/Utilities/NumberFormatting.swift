import Foundation

extension Double {
    /// Short display string: "42.3K", "1.50M", "3.14Sp", "1.23e45", etc.
    var compactFormatted: String {
        guard self.isFinite else { return self.isNaN ? "NaN" : "∞" }
        let a = abs(self)
        switch a {
        case 0..<1_000:              return String(format: "%.1f",    self)
        case 1e3..<1e6:              return String(format: "%.2fK",   self / 1e3)
        case 1e6..<1e9:              return String(format: "%.2fM",   self / 1e6)
        case 1e9..<1e12:             return String(format: "%.2fB",   self / 1e9)
        case 1e12..<1e15:            return String(format: "%.2fT",   self / 1e12)
        case 1e15..<1e18:            return String(format: "%.2fQ",   self / 1e15)
        case 1e18..<1e21:            return String(format: "%.2fQi",  self / 1e18)
        case 1e21..<1e24:            return String(format: "%.2fSx",  self / 1e21)
        case 1e24..<1e27:            return String(format: "%.2fSp",  self / 1e24)
        case 1e27..<1e30:            return String(format: "%.2fOc",  self / 1e27)
        case 1e30..<1e33:            return String(format: "%.2fNo",  self / 1e30)
        case 1e33..<1e36:            return String(format: "%.2fDc",  self / 1e33)
        case 1e36..<1e39:            return String(format: "%.2fUDc", self / 1e36)
        case 1e39..<1e42:            return String(format: "%.2fDDc", self / 1e39)
        case 1e42..<1e45:            return String(format: "%.2fTDc", self / 1e42)
        case 1e45..<1e48:            return String(format: "%.2fQaDc",self / 1e45)
        case 1e48..<1e51:            return String(format: "%.2fQiDc",self / 1e48)
        case 1e51..<1e54:            return String(format: "%.2fSxDc",self / 1e51)
        case 1e54..<1e57:            return String(format: "%.2fSpDc",self / 1e54)
        case 1e57..<1e60:            return String(format: "%.2fOcDc",self / 1e57)
        case 1e60..<1e63:            return String(format: "%.2fNoDc",self / 1e60)
        case 1e63..<1e66:            return String(format: "%.2fVg",  self / 1e63)
        default:
            let exp = Int(floor(log10(a)))
            let mantissa = self / pow(10.0, Double(exp))
            return String(format: "%.2fe%d", mantissa, exp)
        }
    }
}
