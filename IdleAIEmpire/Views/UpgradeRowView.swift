import SwiftUI

struct UpgradeRowView: View {
    let upgrade: Upgrade
    let canAfford: Bool
    let onBuy: () -> Void

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
                }

                Text(upgrade.flavor)
                    .font(.caption)
                    .foregroundColor(.textMuted)

                Text("+\(upgrade.baseComputePerSecond.compactFormatted) /s each")
                    .font(.caption2)
                    .foregroundColor(.neonCyan.opacity(0.6))
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
                .stroke(canAfford ? Color.neonCyan.opacity(0.35) : Color.clear, lineWidth: 1)
        )
    }
}
