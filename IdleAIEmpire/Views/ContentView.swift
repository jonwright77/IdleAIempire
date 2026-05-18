import SwiftUI

private enum GameTab { case upgrades, research, awards }

struct ContentView: View {
    @StateObject private var vm = GameViewModel()
    @Environment(\.scenePhase) private var scenePhase
    @State private var selectedTab: GameTab = .upgrades
    @State private var showSingularity = false
    @State private var prestigeFlashOpacity: Double = 0
    @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding = false

    var body: some View {
        ZStack {
            Color.bgPrimary.ignoresSafeArea()

            VStack(spacing: 0) {
                StatsHeaderView(vm: vm)
                TapButtonView(vm: vm)
                tabBar

                if vm.state.canPrestige {
                    singularityBanner
                }

                tabContent
            }

            // Prestige flash
            Color.neonPurple
                .opacity(prestigeFlashOpacity)
                .ignoresSafeArea()
                .allowsHitTesting(false)
        }
        .onChange(of: scenePhase) { phase in
            if phase == .background { vm.handleBackground() }
            if phase == .active { vm.handleForeground() }
        }
        .onChange(of: vm.state.singularityShards) { _ in
            withAnimation(.easeOut(duration: 0.12)) { prestigeFlashOpacity = 0.45 }
            withAnimation(.easeOut(duration: 0.7).delay(0.12)) { prestigeFlashOpacity = 0 }
        }
        .sheet(isPresented: $vm.showOfflinePopup) {
            OfflineEarningsView(amount: vm.pendingOfflineEarnings)
                .presentationDetents([.medium])
        }
        .sheet(isPresented: $showSingularity) {
            SingularityView(currentShards: vm.state.singularityShards) {
                vm.performPrestige()
            }
            .presentationDetents([.large])
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

    private var tabBar: some View {
        HStack(spacing: 0) {
            tabButton("UPGRADES", tab: .upgrades)
            tabButton("RESEARCH", tab: .research)
            tabButton("AWARDS", tab: .awards)
        }
        .background(Color.bgCard)
    }

    private func tabButton(_ label: String, tab: GameTab) -> some View {
        Button {
            selectedTab = tab
        } label: {
            Text(label)
                .font(.caption.bold())
                .tracking(2)
                .foregroundColor(selectedTab == tab ? .bgPrimary : .textMuted)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 10)
                .background(selectedTab == tab ? Color.neonCyan : Color.clear)
        }
        .buttonStyle(.plain)
        .animation(.easeInOut(duration: 0.15), value: selectedTab)
    }

    private var singularityBanner: some View {
        Button { showSingularity = true } label: {
            HStack {
                Text("◈  SINGULARITY READY")
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
            .overlay(
                Rectangle()
                    .frame(height: 1)
                    .foregroundColor(Color.neonPurple.opacity(0.25)),
                alignment: .bottom
            )
        }
        .buttonStyle(.plain)
    }

    @ViewBuilder
    private var tabContent: some View {
        switch selectedTab {
        case .upgrades: UpgradesListView(vm: vm)
        case .research: ResearchView(vm: vm)
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
