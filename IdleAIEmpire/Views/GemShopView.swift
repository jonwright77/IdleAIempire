import SwiftUI
import Combine

struct GemShopView: View {
    @ObservedObject var vm: GameViewModel
    @Environment(\.dismiss) private var dismiss

    // Drives the countdown redraw without touching game state.
    @State private var tick = 0
    private let refreshTimer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    var body: some View {
        ZStack {
            Color.bgPrimary.ignoresSafeArea()

            VStack(spacing: 0) {
                header
                ScrollView {
                    VStack(spacing: 12) {
                        if vm.shop.totalMultiplier > 1 {
                            activeBoostBanner
                        }
                        timedBoostCard
                        permanentBoostCard
                    }
                    .padding(16)
                }
            }
        }
        .onReceive(refreshTimer) { _ in tick &+= 1 }
    }

    // MARK: - Header

    private var header: some View {
        HStack {
            Button { dismiss() } label: {
                Image(systemName: "xmark")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.textMuted)
                    .frame(width: 32, height: 32)
                    .background(Color.bgCard)
                    .clipShape(Circle())
            }
            .buttonStyle(.plain)

            Spacer()

            HStack(spacing: 6) {
                Text("GEM SHOP")
                    .font(.system(size: 11, weight: .bold, design: .monospaced))
                    .tracking(2)
                    .foregroundColor(.neonGold)
            }

            Spacer()

            HStack(spacing: 4) {
                Text("💎").font(.caption)
                Text("\(vm.gems)")
                    .font(.system(size: 11, weight: .bold, design: .monospaced))
                    .foregroundColor(.neonGold)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
        .background(Color.bgCard)
        .overlay(Rectangle().frame(height: 1).foregroundColor(Color.neonGold.opacity(0.2)), alignment: .bottom)
    }

    // MARK: - Active boost banner

    private var activeBoostBanner: some View {
        HStack(spacing: 10) {
            Text("⚡")
            VStack(alignment: .leading, spacing: 2) {
                Text("BOOST ACTIVE  ×\(formatMultiplier(vm.shop.totalMultiplier))")
                    .font(.system(size: 11, weight: .bold, design: .monospaced))
                    .tracking(1)
                    .foregroundColor(.neonGold)
                if vm.shop.isTimedBoostActive {
                    Text("\(formatDuration(vm.shop.remainingBoostSeconds)) remaining")
                        .font(.caption2)
                        .foregroundColor(.neonGold.opacity(0.7))
                }
            }
            Spacer()
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 10)
        .background(Color.neonGold.opacity(0.12))
        .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.neonGold.opacity(0.35), lineWidth: 1))
        .cornerRadius(10)
    }

    // MARK: - Timed boost card

    private var timedBoostCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 8) {
                Text("⚡")
                    .font(.title2)
                VStack(alignment: .leading, spacing: 2) {
                    Text("NEURAL OVERDRIVE")
                        .font(.system(size: 12, weight: .bold, design: .monospaced))
                        .tracking(1)
                        .foregroundColor(.white)
                    Text("2× all earnings for 2 hours")
                        .font(.caption)
                        .foregroundColor(.textMuted)
                }
                Spacer()
            }

            if vm.shop.isTimedBoostActive {
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text("\(formatDuration(vm.shop.remainingBoostSeconds)) remaining")
                            .font(.caption.bold())
                            .foregroundColor(.neonGold)
                        Spacer()
                        Text("\(Int(vm.shop.remainingBoostSeconds / 3600 * 10) / 10)h / 10h")
                            .font(.caption2)
                            .foregroundColor(.textMuted)
                    }
                    GeometryReader { geo in
                        ZStack(alignment: .leading) {
                            RoundedRectangle(cornerRadius: 3)
                                .fill(Color.white.opacity(0.08))
                            RoundedRectangle(cornerRadius: 3)
                                .fill(Color.neonGold)
                                .frame(width: geo.size.width * CGFloat(min(vm.shop.remainingBoostSeconds / (10 * 3600), 1)))
                        }
                    }
                    .frame(height: 6)
                }
            }

            Divider().background(Color.white.opacity(0.08))

            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text("50 💎 per 2 hours")
                        .font(.caption.bold())
                        .foregroundColor(.neonGold)
                    Text("Max 10 hours total")
                        .font(.caption2)
                        .foregroundColor(.textMuted)
                }
                Spacer()
                Button(action: { vm.buyTimedBoost(); HapticManager.tap() }) {
                    Text("BUY")
                        .font(.caption.bold())
                        .foregroundColor(canBuyTimed ? .bgPrimary : .textMuted)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 10)
                        .background(canBuyTimed ? Color.neonGold : Color.bgPrimary)
                        .cornerRadius(8)
                }
                .disabled(!canBuyTimed)
            }
        }
        .padding(14)
        .background(Color.bgCard)
        .cornerRadius(12)
        .overlay(RoundedRectangle(cornerRadius: 12).stroke(timedBorderColor, lineWidth: 1))
    }

    // MARK: - Permanent boost card

    private var permanentBoostCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 8) {
                Text("◈")
                    .font(.title2)
                    .foregroundColor(.neonPurple)
                VStack(alignment: .leading, spacing: 2) {
                    Text("SYNTHETIC ASCENSION")
                        .font(.system(size: 12, weight: .bold, design: .monospaced))
                        .tracking(1)
                        .foregroundColor(.white)
                    Text("Permanent 2× earnings multiplier")
                        .font(.caption)
                        .foregroundColor(.textMuted)
                }
                Spacer()
            }

            if vm.shop.permanentBoostCount > 0 {
                HStack(spacing: 6) {
                    Text("◈ ×\(vm.shop.permanentBoostCount)")
                        .font(.system(size: 11, weight: .bold, design: .monospaced))
                        .foregroundColor(.neonPurple)
                    Text("= ×\(formatMultiplier(vm.shop.permanentMultiplier)) permanent")
                        .font(.caption2)
                        .foregroundColor(.neonPurple.opacity(0.7))
                }
            }

            Divider().background(Color.white.opacity(0.08))

            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text("\(vm.shop.nextPermanentBoostCost) 💎")
                        .font(.caption.bold())
                        .foregroundColor(.neonPurple)
                    if vm.shop.permanentBoostCount > 0 {
                        Text("Next: ×\(formatMultiplier(vm.shop.permanentMultiplier * 2))")
                            .font(.caption2)
                            .foregroundColor(.textMuted)
                    }
                }
                Spacer()
                Button(action: { vm.buyPermanentBoost() }) {
                    Text("BUY")
                        .font(.caption.bold())
                        .foregroundColor(canBuyPermanent ? .bgPrimary : .textMuted)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 10)
                        .background(canBuyPermanent ? Color.neonPurple : Color.bgPrimary)
                        .cornerRadius(8)
                }
                .disabled(!canBuyPermanent)
            }
        }
        .padding(14)
        .background(Color.bgCard)
        .cornerRadius(12)
        .overlay(RoundedRectangle(cornerRadius: 12).stroke(permanentBorderColor, lineWidth: 1))
    }

    // MARK: - Helpers

    private var canBuyTimed: Bool { vm.gems >= 50 && vm.shop.canAddTimedBoost }
    private var canBuyPermanent: Bool { vm.gems >= vm.shop.nextPermanentBoostCost }

    private var timedBorderColor: Color {
        if vm.shop.isTimedBoostActive { return Color.neonGold.opacity(0.5) }
        if canBuyTimed { return Color.neonGold.opacity(0.3) }
        return Color.clear
    }

    private var permanentBorderColor: Color {
        if vm.shop.permanentBoostCount > 0 { return Color.neonPurple.opacity(0.4) }
        if canBuyPermanent { return Color.neonPurple.opacity(0.3) }
        return Color.clear
    }

    private func formatDuration(_ seconds: TimeInterval) -> String {
        let h = Int(seconds) / 3600
        let m = (Int(seconds) % 3600) / 60
        let s = Int(seconds) % 60
        if h > 0 { return "\(h)h \(m)m" }
        if m > 0 { return "\(m)m \(s)s" }
        return "\(s)s"
    }

    private func formatMultiplier(_ value: Double) -> String {
        let i = Int(value)
        return Double(i) == value ? "\(i)" : String(format: "%.1f", value)
    }
}
