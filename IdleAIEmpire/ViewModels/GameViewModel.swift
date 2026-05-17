import Foundation
import Combine

final class GameViewModel: ObservableObject {
    @Published private(set) var state: GameState

    private var tickTimer: AnyCancellable?
    private var saveTimer: AnyCancellable?

    private let tickRate: TimeInterval = 0.1
    private let maxOfflineSeconds: TimeInterval = 3 * 3600  // cap at 3 hours

    init() {
        var loaded = PersistenceManager.load() ?? GameState()
        loaded.compute += Self.offlineEarnings(for: loaded, cap: 3 * 3600)
        self.state = loaded
        startTimers()
    }

    // MARK: - Actions

    func tap() {
        state.compute += state.computePerTap
    }

    func buyUpgrade(id: String) {
        guard let index = state.upgrades.firstIndex(where: { $0.id == id }) else { return }
        let upgrade = state.upgrades[index]
        guard state.compute >= upgrade.cost else { return }
        state.compute -= upgrade.cost
        state.upgrades[index].owned += 1
    }

    func save() {
        state.lastSaveDate = Date()
        PersistenceManager.save(state)
    }

    // MARK: - Private

    private func startTimers() {
        // Passive income — ticks 10× per second for smooth display
        tickTimer = Timer.publish(every: tickRate, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                guard let self else { return }
                self.state.compute += self.state.computePerSecond * self.tickRate
            }

        // Auto-save every 30 seconds
        saveTimer = Timer.publish(every: 30, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in self?.save() }
    }

    private static func offlineEarnings(for state: GameState, cap: TimeInterval) -> Double {
        let elapsed = Date().timeIntervalSince(state.lastSaveDate)
        return state.computePerSecond * min(elapsed, cap)
    }
}
