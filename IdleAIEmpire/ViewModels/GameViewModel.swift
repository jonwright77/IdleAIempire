import Foundation
import Combine

final class GameViewModel: ObservableObject {
    @Published private(set) var state: GameState
    @Published private(set) var pendingOfflineEarnings: Double = 0
    @Published var showOfflinePopup = false

    private var tickTimer: AnyCancellable?
    private var saveTimer: AnyCancellable?

    private let tickRate: TimeInterval = 0.1

    init() {
        var loaded = PersistenceManager.load() ?? GameState()
        loaded.mergeNewCatalogEntries()
        loaded.mergeNewResearchNodes()
        let offline = Self.offlineEarnings(for: loaded)
        loaded.compute += offline
        self.state = loaded
        if offline >= 1 {
            self.pendingOfflineEarnings = offline
            self.showOfflinePopup = true
        }
        startTimers()
    }

    // MARK: - Actions

    func tap() {
        state.compute += state.effectiveComputePerTap
    }

    func buyUpgrade(id: String) {
        guard let index = state.upgrades.firstIndex(where: { $0.id == id }) else { return }
        let upgrade = state.upgrades[index]
        guard state.compute >= upgrade.cost else { return }
        state.compute -= upgrade.cost
        state.upgrades[index].owned += 1
    }

    func unlockResearch(id: String) {
        guard let index = state.researchNodes.firstIndex(where: { $0.id == id }) else { return }
        let node = state.researchNodes[index]
        guard !node.unlocked, state.compute >= node.cost else { return }
        if index > 0 { guard state.researchNodes[index - 1].unlocked else { return } }
        state.compute -= node.cost
        state.researchNodes[index].unlocked = true
    }

    func save() {
        state.lastSaveDate = Date()
        PersistenceManager.save(state)
    }

    // MARK: - Private

    private func startTimers() {
        tickTimer = Timer.publish(every: tickRate, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                guard let self else { return }
                self.state.compute += self.state.effectiveComputePerSecond * self.tickRate
            }

        saveTimer = Timer.publish(every: 30, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in self?.save() }
    }

    private static func offlineEarnings(for state: GameState) -> Double {
        let elapsed = Date().timeIntervalSince(state.lastSaveDate)
        return state.effectiveComputePerSecond * min(elapsed, state.offlineCap)
    }
}
