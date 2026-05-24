import SwiftUI

struct PlanetSelectView: View {
    @ObservedObject var vm: GameViewModel
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ZStack {
            Color.bgPrimary.ignoresSafeArea()

            VStack(spacing: 0) {
                header
                ScrollView {
                    VStack(spacing: 10) {
                        ForEach(Array(PlanetDefinition.all.enumerated()), id: \.element.id) { index, def in
                            let board = vm.state.planets[index]
                            PlanetCard(
                                definition: def,
                                board: board,
                                isActive: index == vm.state.activePlanetIndex,
                                unlockProgress: unlockProgress(for: index),
                                onTap: {
                                    if board.unlocked {
                                        vm.switchPlanet(to: index)
                                        dismiss()
                                    }
                                }
                            )
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.bottom, 24)
                }
            }
        }
    }

    private var header: some View {
        HStack {
            Text("SOLAR SYSTEM")
                .font(.caption.bold())
                .tracking(4)
                .foregroundColor(.white)
            Spacer()
            Button { dismiss() } label: {
                Image(systemName: "xmark.circle.fill")
                    .font(.title3)
                    .foregroundColor(.textMuted)
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
        .background(Color.bgCard)
    }

    private func unlockProgress(for index: Int) -> (owned: Int, needed: Int)? {
        guard index > 0 else { return nil }
        let prevBoard = vm.state.planets[index - 1]
        guard !vm.state.planets[index].unlocked else { return nil }
        let owned = prevBoard.upgrades.last?.owned ?? 0
        return (owned: owned, needed: 100)
    }
}

private struct PlanetCard: View {
    let definition: PlanetDefinition
    let board: PlanetBoard
    let isActive: Bool
    let unlockProgress: (owned: Int, needed: Int)?
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 14) {
                // Planet emoji
                Text(definition.emoji)
                    .font(.system(size: 38))
                    .frame(width: 52)

                VStack(alignment: .leading, spacing: 5) {
                    HStack(spacing: 8) {
                        Text(definition.name.uppercased())
                            .font(.headline)
                            .foregroundColor(board.unlocked ? .white : .textMuted)

                        if isActive {
                            Text("ACTIVE")
                                .font(.caption2.bold())
                                .foregroundColor(definition.accentColor)
                                .padding(.horizontal, 6)
                                .padding(.vertical, 2)
                                .background(definition.accentColor.opacity(0.15))
                                .cornerRadius(4)
                        }

                        if !board.unlocked {
                            Image(systemName: "lock.fill")
                                .font(.caption)
                                .foregroundColor(.textMuted)
                        }
                    }

                    Text(definition.resourceName.uppercased())
                        .font(.caption2)
                        .tracking(2)
                        .foregroundColor(board.unlocked ? definition.accentColor.opacity(0.7) : .textMuted)

                    if board.unlocked {
                        Text("\(board.effectiveComputePerSecond.compactFormatted)/sec")
                            .font(.caption)
                            .foregroundColor(.textMuted)
                    } else if let progress = unlockProgress {
                        // Progress bar toward unlock
                        VStack(alignment: .leading, spacing: 3) {
                            Text("Unlock: \(progress.owned) / \(progress.needed) \(prevPlanetFinalUpgradeName)")
                                .font(.caption2)
                                .foregroundColor(.textMuted)
                            GeometryReader { geo in
                                ZStack(alignment: .leading) {
                                    RoundedRectangle(cornerRadius: 3)
                                        .fill(Color.white.opacity(0.08))
                                        .frame(height: 4)
                                    RoundedRectangle(cornerRadius: 3)
                                        .fill(definition.accentColor.opacity(0.6))
                                        .frame(width: geo.size.width * min(CGFloat(progress.owned) / CGFloat(progress.needed), 1.0), height: 4)
                                }
                            }
                            .frame(height: 4)
                        }
                    }
                }

                Spacer()

                if board.unlocked && !isActive {
                    Image(systemName: "chevron.right")
                        .font(.caption.bold())
                        .foregroundColor(.textMuted)
                }
            }
            .padding(14)
            .background(
                RoundedRectangle(cornerRadius: 14)
                    .fill(Color.bgCard)
                    .overlay(
                        RoundedRectangle(cornerRadius: 14)
                            .stroke(isActive ? definition.accentColor.opacity(0.5) : Color.clear, lineWidth: 1.5)
                    )
            )
        }
        .buttonStyle(.plain)
        .opacity(board.unlocked ? 1.0 : 0.6)
    }

    private var prevPlanetFinalUpgradeName: String {
        // Show the name of the final upgrade on the previous planet
        guard let idx = PlanetDefinition.all.firstIndex(where: { $0.id == definition.id }),
              idx > 0 else { return "" }
        return PlanetDefinition.all[idx - 1].upgradeCatalog.last?.name ?? ""
    }
}
