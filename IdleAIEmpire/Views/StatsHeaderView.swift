import SwiftUI

struct StatsHeaderView: View {
    @ObservedObject var vm: GameViewModel
    @Environment(\.planetAccent) var accent

    var body: some View {
        VStack(spacing: 6) {
            Text(vm.activePlanetDefinition.resourceName.uppercased())
                .font(.caption)
                .tracking(4)
                .foregroundColor(accent.opacity(0.7))

            Text(vm.activePlanet.compute.compactFormatted)
                .font(.system(size: 52, weight: .bold, design: .monospaced))
                .foregroundColor(.white)
                .contentTransition(.numericText())
                .animation(.easeOut(duration: 0.1), value: vm.activePlanet.compute)

            Text("\(vm.activePlanet.effectiveComputePerSecond.compactFormatted) / sec")
                .font(.subheadline)
                .foregroundColor(accent.opacity(0.6))

            if vm.activePlanet.singularityShards > 0 {
                HStack(spacing: 6) {
                    Text("◈ \(vm.activePlanet.singularityShards) SHARDS")
                    Text("×\(String(format: "%.2f", vm.activePlanet.shardMultiplier))")
                }
                .font(.system(size: 11, weight: .semibold, design: .monospaced))
                .foregroundColor(.neonPurple.opacity(0.8))
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 20)
        .background(Color.bgCard)
    }
}
