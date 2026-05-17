import SwiftUI

struct TapButtonView: View {
    @ObservedObject var vm: GameViewModel
    @State private var scale: CGFloat = 1.0

    var body: some View {
        Button(action: handleTap) {
            ZStack {
                Circle()
                    .fill(Color.bgCard)
                    .overlay(Circle().stroke(Color.neonCyan, lineWidth: 2))
                    .shadow(color: .neonCyan.opacity(0.5), radius: 24)

                VStack(spacing: 6) {
                    Text("⚡")
                        .font(.system(size: 52))
                    Text("+\(vm.state.computePerTap.compactFormatted)")
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundColor(.neonCyan)
                }
            }
            .frame(width: 180, height: 180)
            .scaleEffect(scale)
        }
        .buttonStyle(.plain)
        .padding(.vertical, 28)
    }

    private func handleTap() {
        vm.tap()
        withAnimation(.easeOut(duration: 0.08)) { scale = 0.91 }
        withAnimation(.spring(response: 0.25, dampingFraction: 0.45).delay(0.08)) { scale = 1.0 }
    }
}
