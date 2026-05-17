import SwiftUI

struct OfflineEarningsView: View {
    let amount: Double
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ZStack {
            Color.bgPrimary.ignoresSafeArea()

            VStack(spacing: 32) {
                VStack(spacing: 8) {
                    Text("Welcome Back")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .textCase(.uppercase)
                        .tracking(2)

                    Text("Offline Earnings")
                        .font(.title2.bold())
                        .foregroundColor(.white)
                }

                VStack(spacing: 4) {
                    Text(amount.compactFormatted)
                        .font(.system(size: 52, weight: .bold, design: .monospaced))
                        .foregroundColor(.neonCyan)

                    Text("Compute")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }

                Text("Your empire kept running while you were away.")
                    .font(.callout)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)

                Button {
                    dismiss()
                } label: {
                    Text("Collect")
                        .font(.headline)
                        .foregroundColor(.bgPrimary)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(Color.neonCyan)
                        .cornerRadius(12)
                }
                .padding(.horizontal, 32)
            }
        }
    }
}

#Preview {
    OfflineEarningsView(amount: 12_345.6)
}
