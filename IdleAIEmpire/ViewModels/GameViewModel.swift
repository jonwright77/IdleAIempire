import Foundation
import Combine

final class GameViewModel: ObservableObject {
    @Published private(set) var state: GameState
    @Published private(set) var pendingOfflineEarnings: Double = 0
    @Published var showOfflinePopup = false
    @Published private(set) var toastAchievement: Achievement?
    @Published private(set) var prestigeFlashTrigger: Bool = false
    @Published private(set) var eventPrestigeFlashTrigger: Bool = false

    private var tickTimer: AnyCancellable?
    private var saveTimer: AnyCancellable?
    private var backgroundedAt: Date?
    private var toastTask: DispatchWorkItem?

    private let tickRate: TimeInterval = 0.1

    init() {
        var loaded = PersistenceManager.load() ?? GameState()
        loaded.mergeAll()
        loaded.mergeNewAchievements()

        // Ascension points can never be lower than total shards earned — fix any drift from older saves.
        // Compare shards against (spent + available) so we only award the missing difference.
        for i in loaded.planets.indices {
            let planet = loaded.planets[i]
            let spentPoints = planet.singularityUpgradeLevels.values.reduce(0) { total, level in
                total + Upgrade.singularityLevelData.prefix(level).reduce(0) { $0 + $1.cost }
            }
            let totalAccountedFor = spentPoints + planet.singularityPoints
            if planet.singularityShards > totalAccountedFor {
                loaded.planets[i].singularityPoints += planet.singularityShards - totalAccountedFor
            }
        }

        // Compute offline earnings before mutating state so we can show the popup.
        let idx = loaded.activePlanetIndex
        let planet = loaded.planets[idx]
        let elapsed = Date().timeIntervalSince(planet.lastSaveDate)
        let offlineAmount = planet.effectiveComputePerSecond * min(elapsed, planet.offlineCap)

        Self.applyOfflineEarnings(to: &loaded)
        self.state = loaded

        if offlineAmount >= 1 {
            self.pendingOfflineEarnings = offlineAmount
            self.showOfflinePopup = true
        }
        startTimers()
    }

    // MARK: - Convenience (planets)

    var activePlanet: PlanetBoard {
        get { state.planets[state.activePlanetIndex] }
        set { state.planets[state.activePlanetIndex] = newValue }
    }

    var activePlanetDefinition: PlanetDefinition {
        PlanetDefinition.all[state.activePlanetIndex]
    }

    var currentPrestigeThreshold: Double {
        activePlanetDefinition.singularityThreshold * pow(1.1, Double(activePlanet.singularityShards))
    }

    var canPrestige: Bool {
        activePlanet.compute >= currentPrestigeThreshold
    }

    var canUnlockNextPlanet: Bool {
        let nextIndex = state.activePlanetIndex + 1
        guard nextIndex < PlanetDefinition.all.count else { return false }
        guard !state.planets[nextIndex].unlocked else { return false }
        return (activePlanet.upgrades.last?.owned ?? 0) >= 100
    }

    var canAffordResearch: Bool {
        let nodes = activePlanet.researchNodes
        for (index, node) in nodes.enumerated() {
            guard !node.unlocked else { continue }
            let isAvailable = index == 0 || nodes[index - 1].unlocked
            guard isAvailable else { break }
            return activePlanet.compute >= node.cost
        }
        return false
    }

    // MARK: - Convenience (events)

    var activeEvent: EventBoard {
        get { state.events[0] }
        set { state.events[0] = newValue }
    }

    var activeEventDefinition: EventDefinition { EventDefinition.all[0] }

    var isEventUnlocked: Bool {
        !state.events.isEmpty && state.events[0].unlocked
    }

    var currentEventPrestigeThreshold: Double {
        activeEventDefinition.singularityThreshold * pow(1.1, Double(activeEvent.singularityShards))
    }

    var canEventPrestige: Bool {
        isEventUnlocked && state.events[0].compute >= currentEventPrestigeThreshold
    }

    var canAffordEventResearch: Bool {
        guard isEventUnlocked else { return false }
        let nodes = activeEvent.researchNodes
        for (index, node) in nodes.enumerated() {
            guard !node.unlocked else { continue }
            let isAvailable = index == 0 || nodes[index - 1].unlocked
            guard isAvailable else { break }
            return activeEvent.compute >= node.cost
        }
        return false
    }

    var gems: Int { state.gems }

    // MARK: - Actions

    func tap() {
        activePlanet.compute += activePlanet.effectiveComputePerTap
        checkAchievements()
    }

    func buyUpgrade(id: String) {
        guard let index = activePlanet.upgrades.firstIndex(where: { $0.id == id }) else { return }
        let upgrade = activePlanet.upgrades[index]
        guard activePlanet.compute >= upgrade.cost else { return }
        activePlanet.compute -= upgrade.cost
        activePlanet.upgrades[index].owned += 1
        let newOwned = activePlanet.upgrades[index].owned
        if newOwned % 100 == 0 { HapticManager.milestone() }
        awardPlanetGems(upgradeId: id, owned: newOwned)
        checkAchievements()
    }

    func buyToMilestone(id: String) {
        guard let index = activePlanet.upgrades.firstIndex(where: { $0.id == id }) else { return }
        let upgrade = activePlanet.upgrades[index]
        let totalCost = upgrade.costToNextMilestone
        guard activePlanet.compute >= totalCost else { return }
        activePlanet.compute -= totalCost
        activePlanet.upgrades[index].owned = upgrade.nextMilestone
        HapticManager.milestone()
        awardPlanetGems(upgradeId: id, owned: upgrade.nextMilestone)
        checkAchievements()
    }

    func performPrestige() {
        activePlanet.singularityShards += 1
        activePlanet.singularityPoints += 1
        activePlanet.compute = 0
        for i in activePlanet.upgrades.indices { activePlanet.upgrades[i].owned = 0 }
        for i in activePlanet.researchNodes.indices { activePlanet.researchNodes[i].unlocked = false }
        HapticManager.prestige()
        prestigeFlashTrigger.toggle()
        checkAchievements()
        save()
    }

    func buySingularityUpgrade(upgradeId: String) {
        let currentLevel = activePlanet.singularityUpgradeLevels[upgradeId] ?? 0
        guard currentLevel < Upgrade.singularityLevelData.count else { return }
        let cost = Upgrade.singularityLevelData[currentLevel].cost
        guard activePlanet.singularityPoints >= cost else { return }
        activePlanet.singularityPoints -= cost
        activePlanet.singularityUpgradeLevels[upgradeId] = currentLevel + 1
        HapticManager.purchase()
    }

    func unlockResearch(id: String) {
        guard let index = activePlanet.researchNodes.firstIndex(where: { $0.id == id }) else { return }
        let node = activePlanet.researchNodes[index]
        guard !node.unlocked, activePlanet.compute >= node.cost else { return }
        if index > 0 { guard activePlanet.researchNodes[index - 1].unlocked else { return } }
        activePlanet.compute -= node.cost
        activePlanet.researchNodes[index].unlocked = true
        checkAchievements()
    }

    func switchPlanet(to index: Int) {
        guard index < state.planets.count, state.planets[index].unlocked else { return }
        state.activePlanetIndex = index
    }

    func unlockNextPlanet() {
        guard canUnlockNextPlanet else { return }
        let nextIndex = state.activePlanetIndex + 1
        state.planets[nextIndex].unlocked = true
        HapticManager.milestone()
        checkAchievements()
        save()
    }

    // MARK: - Event actions

    func tapEvent() {
        activeEvent.compute += activeEvent.effectiveComputePerTap
    }

    func buyEventUpgrade(id: String) {
        guard let index = activeEvent.upgrades.firstIndex(where: { $0.id == id }) else { return }
        let upgrade = activeEvent.upgrades[index]
        guard activeEvent.compute >= upgrade.cost else { return }
        activeEvent.compute -= upgrade.cost
        activeEvent.upgrades[index].owned += 1
        let newOwned = activeEvent.upgrades[index].owned
        if newOwned % 100 == 0 { HapticManager.milestone() }
        awardEventGems(upgradeId: id, owned: newOwned)
    }

    func buyEventUpgradeToMilestone(id: String) {
        guard let index = activeEvent.upgrades.firstIndex(where: { $0.id == id }) else { return }
        let upgrade = activeEvent.upgrades[index]
        let totalCost = upgrade.costToNextMilestone
        guard activeEvent.compute >= totalCost else { return }
        activeEvent.compute -= totalCost
        activeEvent.upgrades[index].owned = upgrade.nextMilestone
        HapticManager.milestone()
        awardEventGems(upgradeId: id, owned: upgrade.nextMilestone)
    }

    func performEventPrestige() {
        activeEvent.singularityShards += 1
        activeEvent.singularityPoints += 1
        activeEvent.compute = 0
        for i in activeEvent.upgrades.indices { activeEvent.upgrades[i].owned = 0 }
        for i in activeEvent.researchNodes.indices { activeEvent.researchNodes[i].unlocked = false }
        HapticManager.prestige()
        eventPrestigeFlashTrigger.toggle()
        save()
    }

    func buyEventSingularityUpgrade(upgradeId: String) {
        let currentLevel = activeEvent.singularityUpgradeLevels[upgradeId] ?? 0
        guard currentLevel < Upgrade.singularityLevelData.count else { return }
        let cost = Upgrade.singularityLevelData[currentLevel].cost
        guard activeEvent.singularityPoints >= cost else { return }
        activeEvent.singularityPoints -= cost
        activeEvent.singularityUpgradeLevels[upgradeId] = currentLevel + 1
        HapticManager.purchase()
    }

    func unlockEventResearch(id: String) {
        guard let index = activeEvent.researchNodes.firstIndex(where: { $0.id == id }) else { return }
        let node = activeEvent.researchNodes[index]
        guard !node.unlocked, activeEvent.compute >= node.cost else { return }
        if index > 0 { guard activeEvent.researchNodes[index - 1].unlocked else { return } }
        activeEvent.compute -= node.cost
        activeEvent.researchNodes[index].unlocked = true
    }

    // MARK: - Gem helpers

    private func awardPlanetGems(upgradeId: String, owned: Int) {
        for (threshold, reward) in [(500, 50), (1000, 100)] {
            let key = "\(upgradeId)_\(threshold)"
            guard owned >= threshold, !activePlanet.gemMilestonesEarned.contains(key) else { continue }
            state.gems += reward
            activePlanet.gemMilestonesEarned.insert(key)
        }
    }

    private func awardEventGems(upgradeId: String, owned: Int) {
        for (threshold, reward) in [(500, 50), (1000, 100)] {
            let key = "\(upgradeId)_\(threshold)"
            guard owned >= threshold, !activeEvent.gemMilestonesEarned.contains(key) else { continue }
            state.gems += reward
            activeEvent.gemMilestonesEarned.insert(key)
        }
    }

    func save() {
        let now = Date()
        for i in state.planets.indices { state.planets[i].lastSaveDate = now }
        for i in state.events.indices  { state.events[i].lastSaveDate  = now }
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
        var activePlanetOffline = 0.0
        for i in state.planets.indices where state.planets[i].unlocked {
            let offline = state.planets[i].effectiveComputePerSecond * min(elapsed, state.planets[i].offlineCap)
            guard offline >= 1 else { continue }
            state.planets[i].compute += offline
            if i == state.activePlanetIndex { activePlanetOffline = offline }
        }
        for i in state.events.indices where state.events[i].unlocked {
            let offline = state.events[i].effectiveComputePerSecond * min(elapsed, state.events[i].offlineCap)
            guard offline >= 1 else { continue }
            state.events[i].compute += offline
        }
        if activePlanetOffline >= 1 {
            pendingOfflineEarnings = activePlanetOffline
            showOfflinePopup = true
        }
    }

    // MARK: - Private

    private func startTimers() {
        tickTimer = Timer.publish(every: tickRate, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                guard let self else { return }
                let idx = self.state.activePlanetIndex
                self.state.planets[idx].compute += self.state.planets[idx].effectiveComputePerSecond * self.tickRate
                if self.state.planets[idx].isAutoTapping {
                    self.state.planets[idx].compute += self.state.planets[idx].effectiveComputePerTap * self.tickRate
                }
                for i in self.state.events.indices where self.state.events[i].unlocked {
                    self.state.events[i].compute += self.state.events[i].effectiveComputePerSecond * self.tickRate
                    if self.state.events[i].isAutoTapping {
                        self.state.events[i].compute += self.state.events[i].effectiveComputePerTap * self.tickRate
                    }
                }
                self.checkEventUnlocks()
                self.checkAchievements()
            }

        saveTimer = Timer.publish(every: 30, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in self?.save() }
    }

    private static func applyOfflineEarnings(to state: inout GameState) {
        for i in state.planets.indices where state.planets[i].unlocked {
            let elapsed = Date().timeIntervalSince(state.planets[i].lastSaveDate)
            let offline = state.planets[i].effectiveComputePerSecond * min(elapsed, state.planets[i].offlineCap)
            guard offline >= 1 else { continue }
            state.planets[i].compute += offline
        }
        for i in state.events.indices where state.events[i].unlocked {
            let elapsed = Date().timeIntervalSince(state.events[i].lastSaveDate)
            let offline = state.events[i].effectiveComputePerSecond * min(elapsed, state.events[i].offlineCap)
            guard offline >= 1 else { continue }
            state.events[i].compute += offline
        }
    }

    private func checkEventUnlocks() {
        guard !state.events.isEmpty, !state.events[0].unlocked else { return }
        // June event unlocks when the second planet (Uranus, index 1) is unlocked.
        if state.planets.indices.contains(1) && state.planets[1].unlocked {
            state.events[0].unlocked = true
        }
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

    private func showToast(_ achievement: Achievement) {
        toastTask?.cancel()
        toastAchievement = achievement
        let task = DispatchWorkItem { [weak self] in self?.toastAchievement = nil }
        toastTask = task
        DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: task)
    }

    private func isUnlocked(_ achievement: Achievement) -> Bool {
        let planet = activePlanet
        switch achievement.id {
        case "first_gpu":         return planet.upgrades.contains { $0.id == "gpu" && $0.owned >= 1 }
        case "first_server_rack": return planet.upgrades.contains { $0.id == "server_rack" && $0.owned >= 1 }
        case "first_data_centre": return planet.upgrades.contains { $0.id == "data_centre" && $0.owned >= 1 }
        case "first_ai_cluster":  return planet.upgrades.contains { $0.id == "ai_cluster" && $0.owned >= 1 }
        case "first_orbital":     return planet.upgrades.contains { $0.id == "orbital_station" && $0.owned >= 1 }
        case "first_planetary":   return planet.upgrades.contains { $0.id == "planetary_grid" && $0.owned >= 1 }
        case "auto_tapper":       return planet.isAutoTapping
        case "first_research":    return planet.researchNodes.contains { $0.unlocked }
        case "all_base_research": return planet.researchNodes.prefix(6).allSatisfy { $0.unlocked }
        case "compute_1k":        return planet.compute >= 1_000
        case "compute_1m":        return planet.compute >= 1_000_000
        case "compute_1b":        return planet.compute >= 1_000_000_000
        case "compute_1t":        return planet.compute >= 1_000_000_000_000
        case "first_prestige":    return state.planets.contains { $0.singularityShards >= 1 }
        case "prestige_5":        return state.planets.contains { $0.singularityShards >= 5 }
        case "first_new_planet":  return state.planets.dropFirst().contains { $0.unlocked }
        case "all_planets":       return state.planets.allSatisfy { $0.unlocked }
        default:                  return false
        }
    }
}
