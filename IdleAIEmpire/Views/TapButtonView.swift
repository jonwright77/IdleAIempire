import SwiftUI

private struct TapParticle: Identifiable {
    let id = UUID()
    let label: String
}

private struct FloatingLabel: View {
    let text: String
    @State private var offset: CGFloat = 0
    @State private var opacity: Double = 1

    var body: some View {
        Text(text)
            .font(.headline.bold())
            .foregroundColor(.neonCyan)
            .shadow(color: .neonCyan.opacity(0.6), radius: 4)
            .offset(y: offset)
            .opacity(opacity)
            .allowsHitTesting(false)
            .onAppear {
                withAnimation(.easeOut(duration: 0.75)) {
                    offset = -90
                    opacity = 0
                }
            }
    }
}

private struct AutoTapRing: View {
    @State private var scale: CGFloat = 1.0
    @State private var opacity: Double = 0.6

    var body: some View {
        Circle()
            .stroke(Color.neonCyan, lineWidth: 1.5)
            .frame(width: 148, height: 148)
            .scaleEffect(scale)
            .opacity(opacity)
            .onAppear {
                withAnimation(.easeInOut(duration: 1.0).repeatForever(autoreverses: true)) {
                    scale = 1.1
                    opacity = 0.15
                }
            }
    }
}

struct TapButtonView: View {
    @ObservedObject var vm: GameViewModel
    @State private var scale: CGFloat = 1.0
    @State private var particles: [TapParticle] = []

    var body: some View {
        VStack(spacing: 8) {
            ZStack {
                if vm.activePlanet.isAutoTapping {
                    AutoTapRing()
                }

                Button(action: handleTap) {
                    ZStack {
                        Circle()
                            .fill(Color.bgCard)
                            .overlay(Circle().stroke(Color.neonCyan, lineWidth: 2))
                            .shadow(color: .neonCyan.opacity(0.5), radius: 24)

                        VStack(spacing: 4) {
                            Text("⚡")
                                .font(.system(size: 38))
                            Text("+\(vm.activePlanet.effectiveComputePerTap.compactFormatted)")
                                .font(.caption)
                                .fontWeight(.semibold)
                                .foregroundColor(.neonCyan)
                        }
                    }
                    .frame(width: 136, height: 136)
                    .scaleEffect(scale)
                }
                .buttonStyle(.plain)

                ForEach(particles) { p in
                    FloatingLabel(text: p.label)
                }
            }

            if vm.activePlanet.isAutoTapping {
                Text("● AUTO")
                    .font(.system(size: 10, weight: .bold, design: .monospaced))
                    .foregroundColor(.neonCyan.opacity(0.6))
                    .tracking(3)
            }
        }
        .padding(.vertical, 12)
    }

    private func handleTap() {
        vm.tap()
        HapticManager.tap()
        withAnimation(.easeOut(duration: 0.08)) { scale = 0.91 }
        withAnimation(.spring(response: 0.25, dampingFraction: 0.45).delay(0.08)) { scale = 1.0 }

        let p = TapParticle(label: "+\(vm.activePlanet.effectiveComputePerTap.compactFormatted)")
        particles.append(p)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.9) {
            particles.removeAll { $0.id == p.id }
        }
    }
}
