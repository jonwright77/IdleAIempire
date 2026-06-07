import SwiftUI

struct SingularityView: View {
    let planetName: String
    let currentShards: Int
    let currentPoints: Int
    let shardBase: Double
    let onConfirm: () -> Void
    @Environment(\.dismiss) private var dismiss

    init(planetName: String, currentShards: Int, currentPoints: Int, shardBase: Double = 1.1, onConfirm: @escaping () -> Void) {
        self.planetName = planetName
        self.currentShards = currentShards
        self.currentPoints = currentPoints
        self.shardBase = shardBase
        self.onConfirm = onConfirm
    }

    private var newShards: Int { currentShards + 1 }
    private var newMultiplier: Double { pow(shardBase, Double(newShards)) }
    private var newPoints: Int { currentPoints + 1 }

    var body: some View {
        ZStack {
            Color.bgPrimary.ignoresSafeArea()

            VStack(spacing: 24) {
                // Header
                VStack(spacing: 8) {
                    Text("◈")
                        .font(.system(size: 48))
                        .foregroundColor(.neonPurple)

                    Text(planetName.uppercased())
                        .font(.title.bold())
                        .foregroundColor(.white)

                    Text("Your empire on this world transcends its current form.")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                }
                .padding(.top, 8)

                // What you earn
                VStack(spacing: 1) {
                    infoRow("Singularity Shards", value: "+1  →  \(newShards) total")
                    infoRow("Compute multiplier", value: "×\(String(format: "%.2f", newMultiplier))")
                    infoRow("Singularity Points", value: "+1  →  \(newPoints) to spend")
                }
                .cornerRadius(12)
                .clipped()

                // What is kept / reset
                VStack(spacing: 1) {
                    keepRow("Singularity Shards", kept: true)
                    keepRow("Singularity Upgrades", kept: true)
                    keepRow("Research nodes", kept: false)
                    keepRow("All upgrades", kept: false)
                    keepRow("All Compute", kept: false)
                }
                .cornerRadius(12)
                .clipped()

                Spacer()

                // Action buttons
                VStack(spacing: 12) {
                    Button {
                        onConfirm()
                        dismiss()
                    } label: {
                        Text("INITIATE \(planetName.uppercased())")
                            .font(.headline)
                            .foregroundColor(.bgPrimary)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(Color.neonPurple)
                            .cornerRadius(12)
                    }

                    Button("Cancel") { dismiss() }
                        .font(.subheadline)
                        .foregroundColor(.textMuted)
                }
            }
            .padding(28)
        }
    }

    private func infoRow(_ label: String, value: String) -> some View {
        HStack {
            Text(label)
                .font(.subheadline)
                .foregroundColor(.white)
            Spacer()
            Text(value)
                .font(.subheadline.bold())
                .foregroundColor(.neonPurple)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(Color.bgCard)
    }

    private func keepRow(_ label: String, kept: Bool) -> some View {
        HStack(spacing: 10) {
            Image(systemName: kept ? "checkmark.circle.fill" : "xmark.circle.fill")
                .foregroundColor(kept ? .neonCyan : .red.opacity(0.7))
            Text(label)
                .font(.subheadline)
                .foregroundColor(kept ? .white : .textMuted)
            Spacer()
            Text(kept ? "KEPT" : "RESET")
                .font(.caption2.bold())
                .foregroundColor(kept ? .neonCyan.opacity(0.7) : .red.opacity(0.6))
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(Color.bgCard)
    }
}

#Preview {
    SingularityView(planetName: "Singularity", currentShards: 2, currentPoints: 3, onConfirm: {})
}
