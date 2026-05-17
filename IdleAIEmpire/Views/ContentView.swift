import SwiftUI

struct ContentView: View {
    @StateObject private var vm = GameViewModel()
    @Environment(\.scenePhase) private var scenePhase

    var body: some View {
        ZStack {
            Color.bgPrimary.ignoresSafeArea()

            VStack(spacing: 0) {
                StatsHeaderView(vm: vm)
                TapButtonView(vm: vm)
                UpgradesListView(vm: vm)
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
}

#Preview {
    ContentView()
}
