import SwiftUI

struct ResearchView: View {
    @ObservedObject var vm: GameViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("RESEARCH")
                .font(.caption)
                .tracking(4)
                .foregroundColor(.neonPurple.opacity(0.7))
                .padding(.horizontal, 16)
                .padding(.vertical, 12)

            ScrollView {
                VStack(spacing: 8) {
                    ForEach(Array(vm.activePlanet.researchNodes.enumerated()), id: \.element.id) { index, node in
                        ResearchNodeRow(
                            node: node,
                            isAvailable: index == 0 || vm.activePlanet.researchNodes[index - 1].unlocked,
                            canAfford: vm.activePlanet.compute >= node.cost,
                            onUnlock: { vm.unlockResearch(id: node.id) }
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

private struct ResearchNodeRow: View {
    let node: ResearchNode
    let isAvailable: Bool
    let canAfford: Bool
    let onUnlock: () -> Void

    private var isActionable: Bool { isAvailable && !node.unlocked }

    var body: some View {
        HStack(spacing: 12) {
            VStack(alignment: .leading, spacing: 4) {
                HStack(spacing: 8) {
                    Text(node.name)
                        .font(.headline)
                        .foregroundColor(isAvailable ? .white : .textMuted)

                    if node.unlocked {
                        Text("UNLOCKED")
                            .font(.caption2)
                            .fontWeight(.bold)
                            .foregroundColor(.neonPurple)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(Color.neonPurple.opacity(0.15))
                            .cornerRadius(4)
                    }
                }

                Text(node.flavor)
                    .font(.caption)
                    .foregroundColor(.textMuted)

                Text(node.effectSummary)
                    .font(.caption2)
                    .foregroundColor(.neonPurple.opacity(isAvailable ? 0.8 : 0.35))
            }

            Spacer()

            if node.unlocked {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(.neonPurple)
                    .font(.title2)
            } else {
                Button(action: onUnlock) {
                    VStack(spacing: 2) {
                        Text("UNLOCK")
                            .font(.caption)
                            .fontWeight(.bold)
                        Text(node.cost.compactFormatted)
                            .font(.caption2)
                    }
                    .foregroundColor(buttonForeground)
                    .padding(.horizontal, 14)
                    .padding(.vertical, 10)
                    .background(buttonBackground)
                    .cornerRadius(8)
                }
                .disabled(!isActionable || !canAfford)
            }
        }
        .padding(14)
        .background(Color.bgCard)
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(borderColor, lineWidth: 1)
        )
        .opacity(isAvailable ? 1 : 0.45)
    }

    private var buttonForeground: Color {
        isActionable && canAfford ? .bgPrimary : .textMuted
    }

    private var buttonBackground: Color {
        isActionable && canAfford ? .neonPurple : .bgPrimary
    }

    private var borderColor: Color {
        if node.unlocked { return Color.neonPurple.opacity(0.4) }
        if isActionable && canAfford { return Color.neonPurple.opacity(0.35) }
        return Color.clear
    }
}
