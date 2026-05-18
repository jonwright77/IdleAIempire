import UIKit

// Replace UIImpactFeedbackGenerator / UINotificationFeedbackGenerator calls
// with AVAudioPlayer calls here when audio assets are added.
enum HapticManager {
    static func tap() {
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
    }

    static func purchase() {
        UINotificationFeedbackGenerator().notificationOccurred(.success)
    }

    // Fired when an upgrade crosses a century milestone (100, 200, 300…)
    static func milestone() {
        UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
    }

    // Fired on Singularity prestige
    static func prestige() {
        UINotificationFeedbackGenerator().notificationOccurred(.warning)
    }
}
