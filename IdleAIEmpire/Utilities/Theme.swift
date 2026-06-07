import SwiftUI

extension Color {
    static let bgPrimary        = Color(red: 0.04, green: 0.04, blue: 0.10)
    static let bgCard           = Color(red: 0.10, green: 0.10, blue: 0.18)
    static let neonCyan         = Color(red: 0.00, green: 0.85, blue: 1.00)
    static let neonPurple       = Color(red: 0.55, green: 0.35, blue: 1.00)
    static let neonGold         = Color(red: 1.00, green: 0.78, blue: 0.00)
    static let textMuted        = Color.white.opacity(0.45)

    // Per-planet accent colours
    static let planetNeptune    = Color(red: 0.00, green: 0.85, blue: 1.00)  // neonCyan
    static let planetUranus     = Color(red: 0.45, green: 0.95, blue: 0.85)
    static let planetSaturn     = Color(red: 1.00, green: 0.75, blue: 0.20)
    static let planetJupiter    = Color(red: 1.00, green: 0.50, blue: 0.20)
    static let planetMars       = Color(red: 0.95, green: 0.30, blue: 0.20)
    static let planetEarth      = Color(red: 0.20, green: 0.70, blue: 0.95)
    static let planetVenus      = Color(red: 1.00, green: 0.90, blue: 0.15)
    static let planetMercury    = Color(red: 0.80, green: 0.82, blue: 0.88)
    static let planetSun        = Color(red: 1.00, green: 0.65, blue: 0.00)

    // Monthly event accent colours
    static let eventJune        = Color(red: 0.20, green: 0.95, blue: 0.50)  // midsummer green
}

// Environment key so child views auto-receive the active planet's accent colour.
struct PlanetAccentKey: EnvironmentKey {
    static let defaultValue: Color = .neonCyan
}

extension EnvironmentValues {
    var planetAccent: Color {
        get { self[PlanetAccentKey.self] }
        set { self[PlanetAccentKey.self] = newValue }
    }
}
