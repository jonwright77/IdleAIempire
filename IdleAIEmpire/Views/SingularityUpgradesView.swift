import SwiftUI

struct SingularityUpgradesView: View {
    @ObservedObject var vm: GameViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                Text("ASCEND")
                    .font(.caption)
                    .tracking(4)
                    .foregroundColor(.neonPurple.opacity(0.7))
                Spacer()
                HStack(spacing: 4) {
                    Text("◈")
                        .foregroundColor(.neonPurple)
                    Text("\(vm.activePlanet.singularityPoints) pts available")
                        .font(.caption.bold())
                        .foregroundColor(.neonPurple)
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)

            if vm.activePlanet.singularityPoints == 0 && vm.activePlanet.singularityUpgradeLevels.isEmpty {
                VStack(spacing: 8) {
                    Text("◈")
                        .font(.system(size: 36))
                        .foregroundColor(.neonPurple.opacity(0.3))
                    Text("Complete a Singularity to earn points\nand permanently upgrade your empire.")
                        .font(.subheadline)
                        .foregroundColor(.textMuted)
                        .multilineTextAlignment(.center)
                }
                .frame(maxWidth: .infinity)
                .padding(.top, 60)
            } else {
                ScrollView {
                    VStack(spacing: 8) {
                        ForEach(vm.activePlanet.upgrades) { upgrade in
                            let level = vm.activePlanet.singularityUpgradeLevels[upgrade.id] ?? 0
                            let maxed = level >= Upgrade.singularityLevelData.count
                            let canAfford = !maxed && vm.activePlanet.singularityPoints >= Upgrade.singularityLevelData[level].cost
                            SingularityUpgradeRow(
                                upgrade: upgrade,
                                level: level,
                                canAfford: canAfford,
                                onUpgrade: { vm.buySingularityUpgrade(upgradeId: upgrade.id) }
                            )
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.bottom, 20)
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
    }
}

private struct SingularityUpgradeRow: View {
    let upgrade: Upgrade
    let level: Int
    let canAfford: Bool
    let onUpgrade: () -> Void

    private let maxLevel = Upgrade.singularityLevelData.count
    private var isMaxed: Bool { level >= maxLevel }

    var body: some View {
        HStack(spacing: 12) {
            VStack(alignment: .leading, spacing: 4) {
                HStack(spacing: 8) {
                    Text(upgrade.name)
                        .font(.headline)
                        .foregroundColor(.white)

                    Text("Level \(level) / \(maxLevel)")
                        .font(.caption2.bold())
                        .foregroundColor(isMaxed ? .neonPurple : .textMuted)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background((isMaxed ? Color.neonPurple : Color.white).opacity(0.1))
                        .cornerRadius(4)
                }

                if level > 0 {
                    Text("◈ ×\(formattedMultiplier(Upgrade.singularityMultiplier(forLevel: level))) active")
                        .font(.caption2)
                        .foregroundColor(.neonPurple.opacity(0.85))
                } else {
                    Text("No permanent bonus yet")
                        .font(.caption2)
                        .foregroundColor(.textMuted)
                }

                if !isMaxed {
                    let next = Upgrade.singularityLevelData[level]
                    Text("Level \(level + 1): ×\(formattedMultiplier(next.multiplier))  —  costs \(next.cost) ◈")
                        .font(.caption2)
                        .foregroundColor(.neonPurple.opacity(0.5))
                }
            }

            Spacer()

            if isMaxed {
                Text("MAXED")
                    .font(.caption.bold())
                    .foregroundColor(.neonPurple)
                    .padding(.horizontal, 14)
                    .padding(.vertical, 10)
                    .background(Color.neonPurple.opacity(0.15))
                    .cornerRadius(8)
            } else {
                Button(action: onUpgrade) {
                    VStack(spacing: 2) {
                        Text("UPGRADE")
                            .font(.caption.bold())
                        Text("\(Upgrade.singularityLevelData[level].cost) ◈")
                            .font(.caption2)
                    }
                    .foregroundColor(canAfford ? .bgPrimary : .textMuted)
                    .padding(.horizontal, 14)
                    .padding(.vertical, 10)
                    .background(canAfford ? Color.neonPurple : Color.bgPrimary)
                    .cornerRadius(8)
                }
                .disabled(!canAfford)
            }
        }
        .padding(14)
        .background(Color.bgCard)
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(borderColor, lineWidth: 1)
        )
    }

    private func formattedMultiplier(_ value: Double) -> String {
        value == value.rounded() ? "\(Int(value))" : String(format: "%.1f", value)
    }

    private var borderColor: Color {
        if isMaxed { return Color.neonPurple.opacity(0.5) }
        if level > 0 { return Color.neonPurple.opacity(0.25) }
        if canAfford { return Color.neonPurple.opacity(0.35) }
        return Color.clear
    }
}
