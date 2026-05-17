import SwiftUI

private enum GameTab { case upgrades, research }

struct ContentView: View {
    @StateObject private var vm = GameViewModel()
    @Environment(\.scenePhase) private var scenePhase
    @State private var selectedTab: GameTab = .upgrades

    var body: some View {
        ZStack {
            Color.bgPrimary.ignoresSafeArea()

            VStack(spacing: 0) {
                StatsHeaderView(vm: vm)
                TapButtonView(vm: vm)
                tabBar
                tabContent
            }
        }
        .onChange(of: scenePhase) { phase in
            if phase == .background { vm.save() }
        }
        .sheet(isPresented: $vm.showOfflinePopup) {
            OfflineEarningsView(amount: vm.pendingOfflineEarnings)
                .presentationDetents([.medium])
        }
    }

    private var tabBar: some View {
        HStack(spacing: 0) {
            tabButton("UPGRADES", tab: .upgrades)
            tabButton("RESEARCH", tab: .research)
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

    @ViewBuilder
    private var tabContent: some View {
        switch selectedTab {
        case .upgrades: UpgradesListView(vm: vm)
        case .research: ResearchView(vm: vm)
        }
    }
}

#Preview {
    ContentView()
}
