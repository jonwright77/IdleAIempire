import SwiftUI

struct StatsHeaderView: View {
    @ObservedObject var vm: GameViewModel

    var body: some View {
        VStack(spacing: 6) {
            Text("COMPUTE")
                .font(.caption)
                .tracking(4)
                .foregroundColor(.neonCyan.opacity(0.7))

            Text(vm.state.compute.compactFormatted)
                .font(.system(size: 52, weight: .bold, design: .monospaced))
                .foregroundColor(.white)
                .contentTransition(.numericText())
                .animation(.easeOut(duration: 0.1), value: vm.state.compute)

            Text("\(vm.state.effectiveComputePerSecond.compactFormatted) / sec")
                .font(.subheadline)
                .foregroundColor(.neonCyan.opacity(0.6))
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 28)
        .background(Color.bgCard)
    }
}
