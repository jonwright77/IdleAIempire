import SwiftUI

private enum GameTab { case upgrades, research, ascend, awards }

struct ContentView: View {
    @StateObject private var vm = GameViewModel()
    @Environment(\.scenePhase) private var scenePhase
    @State private var selectedTab: GameTab = .upgrades
    @State private var showSingularity = false
    @State private var showPlanetSelect = false
    @State private var showEvent = false
    @State private var prestigeFlashOpacity: Double = 0
    @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding = false

    private var accent: Color { vm.activePlanetDefinition.accentColor }

    var body: some View {
        ZStack {
            Color.bgPrimary.ignoresSafeArea()

            VStack(spacing: 0) {
                planetSwitcherBar
                StatsHeaderView(vm: vm)
                TapButtonView(vm: vm)
                tabBar

                if vm.canPrestige {
                    singularityBanner
                }

                if vm.canUnlockNextPlanet {
                    unlockNextPlanetBanner
                }

                if vm.isEventUnlocked {
                    eventBanner
                }

                tabContent
            }

            // Prestige flash
            Color.neonPurple
                .opacity(prestigeFlashOpacity)
                .ignoresSafeArea()
                .allowsHitTesting(false)
        }
        .environment(\.planetAccent, accent)
        .onChange(of: scenePhase) { phase in
            if phase == .background { vm.handleBackground() }
            if phase == .active     { vm.handleForeground() }
        }
        .onChange(of: vm.prestigeFlashTrigger) { _ in
            withAnimation(.easeOut(duration: 0.12)) { prestigeFlashOpacity = 0.45 }
            withAnimation(.easeOut(duration: 0.7).delay(0.12)) { prestigeFlashOpacity = 0 }
        }
        .sheet(isPresented: $vm.showOfflinePopup) {
            OfflineEarningsView(amount: vm.pendingOfflineEarnings)
                .presentationDetents([.medium])
        }
        .sheet(isPresented: $showSingularity) {
            SingularityView(
                planetName: vm.activePlanetDefinition.singularityName,
                currentShards: vm.activePlanet.singularityShards,
                currentPoints: vm.activePlanet.singularityPoints,
                nextThreshold: vm.currentPrestigeThreshold * 1.1
            ) {
                vm.performPrestige()
            }
            .presentationDetents([.large])
        }
        .sheet(isPresented: $showPlanetSelect) {
            PlanetSelectView(vm: vm)
                .presentationDetents([.large])
        }
        .sheet(isPresented: $showEvent) {
            EventBoardView(vm: vm)
        }
        .overlay(alignment: .top) {
            if let achievement = vm.toastAchievement {
                AchievementToast(achievement: achievement)
                    .transition(.move(edge: .top).combined(with: .opacity))
                    .zIndex(1)
            }
        }
        .animation(.spring(response: 0.4, dampingFraction: 0.75), value: vm.toastAchievement?.id)
        .overlay {
            if !hasSeenOnboarding {
                OnboardingOverlay { hasSeenOnboarding = true }
                    .zIndex(2)
            }
        }
    }

    // MARK: - Planet switcher bar

    private var planetSwitcherBar: some View {
        Button { showPlanetSelect = true } label: {
            HStack(spacing: 8) {
                Text(vm.activePlanetDefinition.emoji)
                    .font(.body)
                Text(vm.activePlanetDefinition.name.uppercased())
                    .font(.system(size: 11, weight: .bold, design: .monospaced))
                    .tracking(2)
                    .foregroundColor(accent)
                Image(systemName: "chevron.down")
                    .font(.system(size: 9, weight: .bold))
                    .foregroundColor(accent.opacity(0.7))
                Spacer()
                if vm.isEventUnlocked || vm.gems > 0 {
                    HStack(spacing: 4) {
                        Text("💎")
                            .font(.caption)
                        Text("\(vm.gems)")
                            .font(.system(size: 11, weight: .bold, design: .monospaced))
                            .foregroundColor(.neonGold)
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .frame(maxWidth: .infinity)
            .background(Color.bgCard)
            .overlay(
                Rectangle()
                    .frame(height: 1)
                    .foregroundColor(accent.opacity(0.2)),
                alignment: .bottom
            )
        }
        .buttonStyle(.plain)
    }

    // MARK: - Tab bar

    private var tabBar: some View {
        HStack(spacing: 0) {
            tabButton("UPGRADES", tab: .upgrades)
            tabButton("RESEARCH", tab: .research, indicator: vm.canAffordResearch && selectedTab != .research)
            tabButton("ASCEND",   tab: .ascend)
            tabButton("AWARDS",   tab: .awards)
        }
        .background(Color.bgCard)
    }

    private func tabButton(_ label: String, tab: GameTab, indicator: Bool = false) -> some View {
        Button {
            selectedTab = tab
        } label: {
            Text(label)
                .font(.caption.bold())
                .tracking(2)
                .foregroundColor(selectedTab == tab ? .bgPrimary : .textMuted)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 10)
                .background(selectedTab == tab ? accent : Color.clear)
                .overlay(alignment: .topTrailing) {
                    if indicator {
                        Circle()
                            .fill(accent)
                            .frame(width: 6, height: 6)
                            .padding(.trailing, 6)
                            .padding(.top, 4)
                    }
                }
        }
        .buttonStyle(.plain)
        .animation(.easeInOut(duration: 0.15), value: selectedTab)
    }

    // MARK: - Banners

    private var singularityBanner: some View {
        Button { showSingularity = true } label: {
            HStack {
                Text("◈  \(vm.activePlanetDefinition.singularityName.uppercased()) READY")
                    .font(.system(size: 11, weight: .bold, design: .monospaced))
                    .tracking(2)
                    .foregroundColor(.neonPurple)
                Spacer()
                Image(systemName: "chevron.right")
                    .font(.caption.bold())
                    .foregroundColor(.neonPurple.opacity(0.7))
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .background(Color.neonPurple.opacity(0.1))
            .overlay(Rectangle().frame(height: 1).foregroundColor(Color.neonPurple.opacity(0.25)), alignment: .bottom)
        }
        .buttonStyle(.plain)
    }

    private var eventBanner: some View {
        let def = EventDefinition.all[0]
        return Button { showEvent = true } label: {
            HStack {
                Text("\(def.emoji)  \(def.name.uppercased()) — TAP TO PLAY")
                    .font(.system(size: 11, weight: .bold, design: .monospaced))
                    .tracking(2)
                    .foregroundColor(def.accentColor)
                Spacer()
                if vm.canAffordEventResearch {
                    Circle()
                        .fill(def.accentColor)
                        .frame(width: 6, height: 6)
                }
                Image(systemName: "chevron.right")
                    .font(.caption.bold())
                    .foregroundColor(def.accentColor.opacity(0.7))
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .background(def.accentColor.opacity(0.1))
            .overlay(Rectangle().frame(height: 1).foregroundColor(def.accentColor.opacity(0.25)), alignment: .bottom)
        }
        .buttonStyle(.plain)
    }

    private var unlockNextPlanetBanner: some View {
        let nextDef = PlanetDefinition.all[vm.state.activePlanetIndex + 1]
        return Button { vm.unlockNextPlanet() } label: {
            HStack {
                Text("\(nextDef.emoji)  UNLOCK \(nextDef.name.uppercased())")
                    .font(.system(size: 11, weight: .bold, design: .monospaced))
                    .tracking(2)
                    .foregroundColor(nextDef.accentColor)
                Spacer()
                Image(systemName: "chevron.right")
                    .font(.caption.bold())
                    .foregroundColor(nextDef.accentColor.opacity(0.7))
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .background(nextDef.accentColor.opacity(0.1))
            .overlay(Rectangle().frame(height: 1).foregroundColor(nextDef.accentColor.opacity(0.25)), alignment: .bottom)
        }
        .buttonStyle(.plain)
    }

    // MARK: - Tab content

    @ViewBuilder
    private var tabContent: some View {
        switch selectedTab {
        case .upgrades: UpgradesListView(vm: vm)
        case .research: ResearchView(vm: vm)
        case .ascend:   SingularityUpgradesView(vm: vm)
        case .awards:   AchievementsView(vm: vm)
        }
    }
}

// MARK: - Onboarding

private struct OnboardingOverlay: View {
    let onDismiss: () -> Void

    var body: some View {
        ZStack {
            Color.black.opacity(0.85).ignoresSafeArea()

            VStack(spacing: 32) {
                VStack(spacing: 8) {
                    Text("⚡")
                        .font(.system(size: 48))
                    Text("IDLE AI EMPIRE")
                        .font(.title2.bold())
                        .foregroundColor(.white)
                        .tracking(2)
                }

                VStack(alignment: .leading, spacing: 16) {
                    tip(icon: "cursorarrow.click", text: "Tap the button to earn Compute.")
                    tip(icon: "arrow.up.right.circle", text: "Buy upgrades to earn Compute passively.")
                    tip(icon: "magnifyingglass", text: "Unlock Research nodes for permanent multipliers.")
                    tip(icon: "bolt.fill", text: "Buy 25 GPUs to unlock the Auto-Tapper.")
                }
                .padding(.horizontal, 8)

                Button {
                    onDismiss()
                } label: {
                    Text("START BUILDING")
                        .font(.headline)
                        .foregroundColor(.bgPrimary)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(Color.neonCyan)
                        .cornerRadius(12)
                }
            }
            .padding(32)
        }
    }

    private func tip(icon: String, text: String) -> some View {
        HStack(spacing: 14) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(.neonCyan)
                .frame(width: 28)
            Text(text)
                .font(.subheadline)
                .foregroundColor(.white.opacity(0.85))
        }
    }
}

#Preview {
    ContentView()
}
