import SwiftUI

struct UpgradesListView: View {
    @ObservedObject var vm: GameViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("UPGRADES")
                .font(.caption)
                .tracking(4)
                .foregroundColor(.neonCyan.opacity(0.7))
                .padding(.horizontal, 16)
                .padding(.vertical, 12)

            ScrollView {
                VStack(spacing: 8) {
                    ForEach(vm.state.upgrades) { upgrade in
                        UpgradeRowView(
                            upgrade: upgrade,
                            canAfford: vm.state.compute >= upgrade.cost,
                            onBuy: {
                                vm.buyUpgrade(id: upgrade.id)
                                HapticManager.purchase()
                            }
                        )
                    }
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 20)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
    }
}
