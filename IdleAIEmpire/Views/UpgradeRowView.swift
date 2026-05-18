import SwiftUI

struct UpgradeRowView: View {
    let upgrade: Upgrade
    let canAfford: Bool
    let onBuy: () -> Void

    @State private var affordableGlow = false

    var body: some View {
        HStack(spacing: 12) {
            // Info
            VStack(alignment: .leading, spacing: 4) {
                HStack(spacing: 8) {
                    Text(upgrade.name)
                        .font(.headline)
                        .foregroundColor(.white)

                    if upgrade.owned > 0 {
                        Text("×\(upgrade.owned)")
                            .font(.caption)
                            .fontWeight(.semibold)
                            .foregroundColor(.neonCyan)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(Color.neonCyan.opacity(0.15))
                            .cornerRadius(4)
                    }

                    if upgrade.milestones > 0 {
                        Text("★ ×\(Int(upgrade.milestoneMultiplier))")
                            .font(.caption2.bold())
                            .foregroundColor(.neonGold)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(Color.neonGold.opacity(0.15))
                            .cornerRadius(4)
                    }
                }

                Text(upgrade.flavor)
                    .font(.caption)
                    .foregroundColor(.textMuted)

                HStack(spacing: 6) {
                    Text("+\(upgrade.baseComputePerSecond.compactFormatted)/s each")
                        .font(.caption2)
                        .foregroundColor(.neonCyan.opacity(0.6))

                    if upgrade.owned > 0 {
                        Text("·  \(upgrade.computePerSecond.compactFormatted)/s total")
                            .font(.caption2)
                            .foregroundColor(
                                upgrade.milestones > 0 ? .neonGold.opacity(0.85) : .neonCyan.opacity(0.4)
                            )
                    }
                }

                if upgrade.owned > 0 {
                    let toNext = 100 - (upgrade.owned % 100)
                    Text("★ milestone in \(toNext)")
                        .font(.caption2)
                        .foregroundColor(.neonGold.opacity(0.45))
                }
            }

            Spacer()

            // Buy button
            Button(action: onBuy) {
                VStack(spacing: 2) {
                    Text("BUY")
                        .font(.caption)
                        .fontWeight(.bold)
                    Text(upgrade.cost.compactFormatted)
                        .font(.caption2)
                }
                .foregroundColor(canAfford ? .bgPrimary : .textMuted)
                .padding(.horizontal, 14)
                .padding(.vertical, 10)
                .background(canAfford ? Color.neonCyan : Color.bgPrimary)
                .cornerRadius(8)
            }
            .disabled(!canAfford)
        }
        .padding(14)
        .background(Color.bgCard)
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(borderColor, lineWidth: affordableGlow ? 2 : 1)
        )
        .shadow(
            color: affordableGlow ? Color.neonCyan.opacity(0.5) : .clear,
            radius: affordableGlow ? 10 : 0
        )
        .animation(.easeOut(duration: 0.3), value: affordableGlow)
        .onChange(of: canAfford) { nowAffordable in
            guard nowAffordable else { return }
            affordableGlow = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
                affordableGlow = false
            }
        }
    }

    private var borderColor: Color {
        if upgrade.milestones > 0 { return Color.neonGold.opacity(0.35) }
        if affordableGlow { return Color.neonCyan.opacity(0.8) }
        if canAfford { return Color.neonCyan.opacity(0.35) }
        return Color.clear
    }
}
