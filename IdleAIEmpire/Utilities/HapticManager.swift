import UIKit

// Sound placeholder — swap the UIImpactFeedbackGenerator calls for
// AVAudioPlayer calls here when audio assets are ready.
enum HapticManager {
    static func tap() {
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
    }

    static func purchase() {
        UINotificationFeedbackGenerator().notificationOccurred(.success)
    }
}
