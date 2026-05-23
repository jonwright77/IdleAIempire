import Foundation
import Combine

final class GameViewModel: ObservableObject {
    @Published private(set) var state: GameState
    @Published private(set) var pendingOfflineEarnings: Double = 0
    @Published var showOfflinePopup = false
    @Published private(set) var toastAchievement: Achievement?

    private var tickTimer: AnyCancellable?
    private var saveTimer: AnyCancellable?
    private var backgroundedAt: Date?
    private var toastTask: DispatchWorkItem?

    private let tickRate: TimeInterval = 0.1

    init() {
        var loaded = PersistenceManager.load() ?? GameState()
        loaded.mergeNewCatalogEntries()
        loaded.mergeNewResearchNodes()
        loaded.mergeNewAchievements()
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
        checkAchievements()
    }

    func buyUpgrade(id: String) {
        guard let index = state.upgrades.firstIndex(where: { $0.id == id }) else { return }
        let upgrade = state.upgrades[index]
        guard state.compute >= upgrade.cost else { return }
        state.compute -= upgrade.cost
        state.upgrades[index].owned += 1
        if state.upgrades[index].owned % 100 == 0 {
            HapticManager.milestone()
        }
        checkAchievements()
    }

    func buyToMilestone(id: String) {
        guard let index = state.upgrades.firstIndex(where: { $0.id == id }) else { return }
        let upgrade = state.upgrades[index]
        let totalCost = upgrade.costToNextMilestone
        guard state.compute >= totalCost else { return }
        state.compute -= totalCost
        state.upgrades[index].owned = upgrade.nextMilestone
        HapticManager.milestone()
        checkAchievements()
    }

    func performPrestige() {
        state.singularityShards += 1
        state.singularityPoints += 1
        state.compute = 0
        for i in state.upgrades.indices { state.upgrades[i].owned = 0 }
        for i in state.researchNodes.indices { state.researchNodes[i].unlocked = false }
        HapticManager.prestige()
        checkAchievements()
        save()
    }

    func buySingularityUpgrade(upgradeId: String) {
        let currentLevel = state.singularityUpgradeLevels[upgradeId] ?? 0
        guard currentLevel < Upgrade.singularityLevelData.count else { return }
        let cost = Upgrade.singularityLevelData[currentLevel].cost
        guard state.singularityPoints >= cost else { return }
        state.singularityPoints -= cost
        state.singularityUpgradeLevels[upgradeId] = currentLevel + 1
        HapticManager.purchase()
    }

    func unlockResearch(id: String) {
        guard let index = state.researchNodes.firstIndex(where: { $0.id == id }) else { return }
        let node = state.researchNodes[index]
        guard !node.unlocked, state.compute >= node.cost else { return }
        if index > 0 { guard state.researchNodes[index - 1].unlocked else { return } }
        state.compute -= node.cost
        state.researchNodes[index].unlocked = true
        checkAchievements()
    }

    var canAffordResearch: Bool {
        for (index, node) in state.researchNodes.enumerated() {
            guard !node.unlocked else { continue }
            let isAvailable = index == 0 || state.researchNodes[index - 1].unlocked
            guard isAvailable else { break }
            return state.compute >= node.cost
        }
        return false
    }

    func save() {
        state.lastSaveDate = Date()
        PersistenceManager.save(state)
    }

    func handleBackground() {
        backgroundedAt = Date()
        save()
    }

    func handleForeground() {
        guard let since = backgroundedAt else { return }
        backgroundedAt = nil
        let elapsed = Date().timeIntervalSince(since)
        let offline = state.effectiveComputePerSecond * min(elapsed, state.offlineCap)
        guard offline >= 1 else { return }
        state.compute += offline
        pendingOfflineEarnings = offline
        showOfflinePopup = true
    }

    // MARK: - Private

    private func startTimers() {
        tickTimer = Timer.publish(every: tickRate, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                guard let self else { return }
                self.state.compute += self.state.effectiveComputePerSecond * self.tickRate
                if self.state.isAutoTapping {
                    self.state.compute += self.state.effectiveComputePerTap * self.tickRate
                }
                self.checkAchievements()
            }

        saveTimer = Timer.publish(every: 30, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in self?.save() }
    }

    private static func offlineEarnings(for state: GameState) -> Double {
        let elapsed = Date().timeIntervalSince(state.lastSaveDate)
        return state.effectiveComputePerSecond * min(elapsed, state.offlineCap)
    }

    // MARK: - Achievements

    private func checkAchievements() {
        for i in state.achievements.indices {
            guard !state.achievements[i].unlocked else { continue }
            if isUnlocked(state.achievements[i]) {
                state.achievements[i].unlocked = true
                showToast(state.achievements[i])
            }
        }
    }

    private func isUnlocked(_ a: Achievement) -> Bool {
        switch a.id {
        case "first_gpu":         return owned("gpu") >= 1
        case "first_server_rack": return owned("server_rack") >= 1
        case "first_data_centre": return owned("data_centre") >= 1
        case "first_ai_cluster":  return owned("ai_cluster") >= 1
        case "first_orbital":     return owned("orbital_station") >= 1
        case "first_planetary":   return owned("planetary_grid") >= 1
        case "auto_tapper":       return state.isAutoTapping
        case "first_research":    return state.researchNodes.contains { $0.unlocked }
        case "all_base_research": return state.researchNodes.prefix(6).allSatisfy { $0.unlocked }
        case "compute_1k":        return state.compute >= 1_000
        case "compute_1m":        return state.compute >= 1_000_000
        case "compute_1b":        return state.compute >= 1_000_000_000
        case "compute_1t":        return state.compute >= 1_000_000_000_000
        case "first_prestige":    return state.singularityShards >= 1
        case "prestige_5":        return state.singularityShards >= 5
        default:                  return false
        }
    }

    private func owned(_ id: String) -> Int {
        state.upgrades.first { $0.id == id }?.owned ?? 0
    }

    private func showToast(_ achievement: Achievement) {
        HapticManager.purchase()
        toastTask?.cancel()
        toastAchievement = achievement
        let task = DispatchWorkItem { [weak self] in
            self?.toastAchievement = nil
        }
        toastTask = task
        DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: task)
    }
}
