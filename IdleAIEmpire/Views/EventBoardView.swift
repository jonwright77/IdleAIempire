import SwiftUI

struct EventBoardView: View {
    @ObservedObject var vm: GameViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var selectedTab: EventTab = .upgrades
    @State private var showConvergence = false
    @State private var convergenceFlashOpacity: Double = 0

    private enum EventTab { case upgrades, research, ascend }

    private let def = EventDefinition.all[0]
    private var event: EventBoard { vm.activeEvent }
    private var accent: Color { def.accentColor }

    var body: some View {
        ZStack {
            Color.bgPrimary.ignoresSafeArea()

            VStack(spacing: 0) {
                headerBar
                eventStatsHeader
                EventTapButton(vm: vm, accent: accent)
                eventTabBar
                if vm.canEventPrestige { convergenceBanner }
                eventTabContent
            }

            Color.eventJune
                .opacity(convergenceFlashOpacity)
                .ignoresSafeArea()
                .allowsHitTesting(false)
        }
        .onChange(of: vm.eventPrestigeFlashTrigger) { _ in
            withAnimation(.easeOut(duration: 0.12)) { convergenceFlashOpacity = 0.45 }
            withAnimation(.easeOut(duration: 0.7).delay(0.12)) { convergenceFlashOpacity = 0 }
        }
        .sheet(isPresented: $showConvergence) {
            SingularityView(
                planetName: def.singularityName,
                currentShards: event.singularityShards,
                currentPoints: event.singularityPoints,
                shardBase: 1.5
            ) {
                vm.performEventPrestige()
            }
            .presentationDetents([.large])
        }
    }

    // MARK: - Header

    private var headerBar: some View {
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
                Text(def.emoji)
                    .font(.body)
                Text(def.name.uppercased())
                    .font(.system(size: 11, weight: .bold, design: .monospaced))
                    .tracking(2)
                    .foregroundColor(accent)
            }

            Spacer()

            // Spacer to balance the X button
            Color.clear.frame(width: 32, height: 32)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
        .background(Color.bgCard)
        .overlay(Rectangle().frame(height: 1).foregroundColor(accent.opacity(0.2)), alignment: .bottom)
    }

    // MARK: - Stats

    private var eventStatsHeader: some View {
        VStack(spacing: 6) {
            Text(def.resourceName.uppercased())
                .font(.caption)
                .tracking(4)
                .foregroundColor(accent.opacity(0.7))

            Text(event.compute.compactFormatted)
                .font(.system(size: 52, weight: .bold, design: .monospaced))
                .foregroundColor(.white)
                .contentTransition(.numericText())
                .animation(.easeOut(duration: 0.1), value: event.compute)

            Text("\(event.effectiveComputePerSecond.compactFormatted) / sec")
                .font(.subheadline)
                .foregroundColor(accent.opacity(0.6))

            if event.singularityShards > 0 {
                HStack(spacing: 6) {
                    Text("◈ \(event.singularityShards) SHARDS")
                    Text("×\(String(format: "%.2f", event.shardMultiplier))")
                }
                .font(.system(size: 11, weight: .semibold, design: .monospaced))
                .foregroundColor(.neonPurple.opacity(0.8))
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 20)
        .background(Color.bgCard)
    }

    // MARK: - Tab bar

    private var eventTabBar: some View {
        HStack(spacing: 0) {
            eventTabButton("BLOOM", tab: .upgrades)
            eventTabButton("RESEARCH", tab: .research, indicator: vm.canAffordEventResearch && selectedTab != .research)
            eventTabButton("ASCEND", tab: .ascend)
        }
        .background(Color.bgCard)
    }

    private func eventTabButton(_ label: String, tab: EventTab, indicator: Bool = false) -> some View {
        Button { selectedTab = tab } label: {
            Text(label)
                .font(.caption.bold())
                .tracking(2)
                .foregroundColor(selectedTab == tab ? .bgPrimary : .textMuted)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 10)
                .background(selectedTab == tab ? accent : Color.clear)
                .overlay(alignment: .topTrailing) {
                    if indicator {
                        Circle().fill(accent).frame(width: 6, height: 6)
                            .padding(.trailing, 6).padding(.top, 4)
                    }
                }
        }
        .buttonStyle(.plain)
        .animation(.easeInOut(duration: 0.15), value: selectedTab)
    }

    // MARK: - Convergence banner

    private var convergenceBanner: some View {
        Button { showConvergence = true } label: {
            HStack {
                Text("◈  \(def.singularityName.uppercased()) READY")
                    .font(.system(size: 11, weight: .bold, design: .monospaced))
                    .tracking(2)
                    .foregroundColor(.neonPurple)
                Spacer()
                Image(systemName: "chevron.right")
                    .font(.caption.bold())
                    .foregroundColor(.neonPurple.opacity(0.7))
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .background(Color.neonPurple.opacity(0.1))
            .overlay(Rectangle().frame(height: 1).foregroundColor(Color.neonPurple.opacity(0.25)), alignment: .bottom)
        }
        .buttonStyle(.plain)
    }

    // MARK: - Tab content

    @ViewBuilder
    private var eventTabContent: some View {
        switch selectedTab {
        case .upgrades: EventUpgradesView(vm: vm, accent: accent)
        case .research: EventResearchView(vm: vm)
        case .ascend:   EventAscendView(vm: vm)
        }
    }
}

// MARK: - Tap Button

private struct EventTapButton: View {
    @ObservedObject var vm: GameViewModel
    let accent: Color
    @State private var scale: CGFloat = 1.0
    @State private var particles: [EventParticle] = []

    var body: some View {
        VStack(spacing: 8) {
            ZStack {
                if vm.activeEvent.isAutoTapping {
                    EventAutoRing(accent: accent)
                }

                Button(action: handleTap) {
                    ZStack {
                        Circle()
                            .fill(Color.bgCard)
                            .overlay(Circle().stroke(accent, lineWidth: 2))
                            .shadow(color: accent.opacity(0.4), radius: 24)

                        VStack(spacing: 6) {
                            Text(EventDefinition.all[0].emoji)
                                .font(.system(size: 52))
                            Text("+\(vm.activeEvent.effectiveComputePerTap.compactFormatted)")
                                .font(.caption.bold())
                                .foregroundColor(accent)
                        }
                    }
                    .frame(width: 180, height: 180)
                    .scaleEffect(scale)
                }
                .buttonStyle(.plain)

                ForEach(particles) { p in
                    EventFloatingLabel(text: p.label, accent: accent)
                }
            }

            if vm.activeEvent.isAutoTapping {
                Text("● AUTO")
                    .font(.system(size: 10, weight: .bold, design: .monospaced))
                    .foregroundColor(accent.opacity(0.6))
                    .tracking(3)
            }
        }
        .padding(.vertical, 28)
    }

    private func handleTap() {
        vm.tapEvent()
        HapticManager.tap()
        withAnimation(.easeOut(duration: 0.08)) { scale = 0.91 }
        withAnimation(.spring(response: 0.25, dampingFraction: 0.45).delay(0.08)) { scale = 1.0 }
        let p = EventParticle(label: "+\(vm.activeEvent.effectiveComputePerTap.compactFormatted)")
        particles.append(p)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.9) {
            particles.removeAll { $0.id == p.id }
        }
    }
}

private struct EventParticle: Identifiable {
    let id = UUID()
    let label: String
}

private struct EventAutoRing: View {
    let accent: Color
    @State private var scale: CGFloat = 1.0
    @State private var opacity: Double = 0.6

    var body: some View {
        Circle().stroke(accent, lineWidth: 1.5)
            .frame(width: 194, height: 194)
            .scaleEffect(scale).opacity(opacity)
            .onAppear {
                withAnimation(.easeInOut(duration: 1.0).repeatForever(autoreverses: true)) {
                    scale = 1.1; opacity = 0.15
                }
            }
    }
}

private struct EventFloatingLabel: View {
    let text: String
    let accent: Color
    @State private var offset: CGFloat = 0
    @State private var opacity: Double = 1

    var body: some View {
        Text(text)
            .font(.headline.bold())
            .foregroundColor(accent)
            .shadow(color: accent.opacity(0.6), radius: 4)
            .offset(y: offset).opacity(opacity)
            .allowsHitTesting(false)
            .onAppear {
                withAnimation(.easeOut(duration: 0.75)) { offset = -90; opacity = 0 }
            }
    }
}

// MARK: - Upgrades tab

private struct EventUpgradesView: View {
    @ObservedObject var vm: GameViewModel
    let accent: Color

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("BLOOM UPGRADES")
                .font(.caption).tracking(4)
                .foregroundColor(accent.opacity(0.7))
                .padding(.horizontal, 16).padding(.vertical, 12)

            ScrollView {
                VStack(spacing: 8) {
                    ForEach(vm.activeEvent.upgrades) { upgrade in
                        let level = vm.activeEvent.singularityUpgradeLevels[upgrade.id] ?? 0
                        let fullMult = Upgrade.singularityMultiplier(forLevel: level)
                            * vm.activeEvent.effectiveCPSMultiplier
                            * vm.activeEvent.shardMultiplier
                        UpgradeRowView(
                            upgrade: upgrade,
                            canAfford: vm.activeEvent.compute >= upgrade.cost,
                            canAffordMilestone: vm.activeEvent.compute >= upgrade.costToNextMilestone,
                            fullMultiplier: fullMult,
                            onBuy: {
                                vm.buyEventUpgrade(id: upgrade.id)
                                HapticManager.purchase()
                            },
                            onBuyMilestone: { vm.buyEventUpgradeToMilestone(id: upgrade.id) }
                        )
                    }
                }
                .padding(.horizontal, 16).padding(.bottom, 20)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
    }
}

// MARK: - Research tab

private struct EventResearchView: View {
    @ObservedObject var vm: GameViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("RESEARCH")
                .font(.caption).tracking(4)
                .foregroundColor(.neonPurple.opacity(0.7))
                .padding(.horizontal, 16).padding(.vertical, 12)

            ScrollView {
                VStack(spacing: 8) {
                    ForEach(Array(vm.activeEvent.researchNodes.enumerated()), id: \.element.id) { index, node in
                        EventResearchRow(
                            node: node,
                            isAvailable: index == 0 || vm.activeEvent.researchNodes[index - 1].unlocked,
                            canAfford: vm.activeEvent.compute >= node.cost,
                            onUnlock: { vm.unlockEventResearch(id: node.id) }
                        )
                    }
                }
                .padding(.horizontal, 16).padding(.bottom, 20)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
    }
}

private struct EventResearchRow: View {
    let node: ResearchNode
    let isAvailable: Bool
    let canAfford: Bool
    let onUnlock: () -> Void

    private var isActionable: Bool { isAvailable && !node.unlocked }

    var body: some View {
        HStack(spacing: 12) {
            VStack(alignment: .leading, spacing: 4) {
                HStack(spacing: 8) {
                    Text(node.name).font(.headline)
                        .foregroundColor(isAvailable ? .white : .textMuted)
                    if node.unlocked {
                        Text("UNLOCKED").font(.caption2.bold()).foregroundColor(.neonPurple)
                            .padding(.horizontal, 6).padding(.vertical, 2)
                            .background(Color.neonPurple.opacity(0.15)).cornerRadius(4)
                    }
                }
                Text(node.flavor).font(.caption).foregroundColor(.textMuted)
                Text(node.effectSummary).font(.caption2)
                    .foregroundColor(.neonPurple.opacity(isAvailable ? 0.8 : 0.35))
            }
            Spacer()
            if node.unlocked {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(.neonPurple).font(.title2)
            } else {
                Button(action: onUnlock) {
                    VStack(spacing: 2) {
                        Text("UNLOCK").font(.caption.bold())
                        Text(node.cost.compactFormatted).font(.caption2)
                    }
                    .foregroundColor(isActionable && canAfford ? .bgPrimary : .textMuted)
                    .padding(.horizontal, 14).padding(.vertical, 10)
                    .background(isActionable && canAfford ? Color.neonPurple : Color.bgPrimary)
                    .cornerRadius(8)
                }
                .disabled(!isActionable || !canAfford)
            }
        }
        .padding(14).background(Color.bgCard).cornerRadius(12)
        .overlay(RoundedRectangle(cornerRadius: 12).stroke(borderColor, lineWidth: 1))
        .opacity(isAvailable ? 1 : 0.45)
    }

    private var borderColor: Color {
        if node.unlocked { return Color.neonPurple.opacity(0.4) }
        if isActionable && canAfford { return Color.neonPurple.opacity(0.35) }
        return Color.clear
    }
}

// MARK: - Ascend tab

private struct EventAscendView: View {
    @ObservedObject var vm: GameViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                Text("BLOOM ASCEND")
                    .font(.caption).tracking(4).foregroundColor(.neonPurple.opacity(0.7))
                Spacer()
                HStack(spacing: 4) {
                    Text("◈").foregroundColor(.neonPurple)
                    Text("\(vm.activeEvent.singularityPoints) pts available")
                        .font(.caption.bold()).foregroundColor(.neonPurple)
                }
            }
            .padding(.horizontal, 16).padding(.vertical, 12)

            if vm.activeEvent.singularityPoints == 0 && vm.activeEvent.singularityUpgradeLevels.isEmpty {
                VStack(spacing: 8) {
                    Text("◈").font(.system(size: 36)).foregroundColor(.neonPurple.opacity(0.3))
                    Text("Complete a Midsummer Convergence to earn points.")
                        .font(.subheadline).foregroundColor(.textMuted)
                        .multilineTextAlignment(.center)
                }
                .frame(maxWidth: .infinity).padding(.top, 60)
            } else {
                ScrollView {
                    VStack(spacing: 8) {
                        ForEach(vm.activeEvent.upgrades) { upgrade in
                            let level = vm.activeEvent.singularityUpgradeLevels[upgrade.id] ?? 0
                            let maxed = level >= Upgrade.singularityLevelData.count
                            let canAfford = !maxed && vm.activeEvent.singularityPoints >= Upgrade.singularityLevelData[level].cost
                            EventAscendRow(
                                upgrade: upgrade, level: level, canAfford: canAfford,
                                onUpgrade: { vm.buyEventSingularityUpgrade(upgradeId: upgrade.id) }
                            )
                        }
                    }
                    .padding(.horizontal, 16).padding(.bottom, 20)
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
    }
}

private struct EventAscendRow: View {
    let upgrade: Upgrade
    let level: Int
    let canAfford: Bool
    let onUpgrade: () -> Void

    private let maxLevel = Upgrade.singularityLevelData.count
    private var isMaxed: Bool { level >= maxLevel }

    var body: some View {
        HStack(spacing: 12) {
            VStack(alignment: .leading, spacing: 4) {
                HStack(spacing: 8) {
                    Text(upgrade.name).font(.headline).foregroundColor(.white)
                    Text("Level \(level) / \(maxLevel)")
                        .font(.caption2.bold())
                        .foregroundColor(isMaxed ? .neonPurple : .textMuted)
                        .padding(.horizontal, 6).padding(.vertical, 2)
                        .background((isMaxed ? Color.neonPurple : Color.white).opacity(0.1))
                        .cornerRadius(4)
                }
                if level > 0 {
                    Text("◈ ×\(formatted(Upgrade.singularityMultiplier(forLevel: level))) active")
                        .font(.caption2).foregroundColor(.neonPurple.opacity(0.85))
                } else {
                    Text("No permanent bonus yet").font(.caption2).foregroundColor(.textMuted)
                }
                if !isMaxed {
                    let next = Upgrade.singularityLevelData[level]
                    Text("Level \(level + 1): ×\(formatted(next.multiplier))  —  costs \(next.cost) ◈")
                        .font(.caption2).foregroundColor(.neonPurple.opacity(0.5))
                }
            }
            Spacer()
            if isMaxed {
                Text("MAXED").font(.caption.bold()).foregroundColor(.neonPurple)
                    .padding(.horizontal, 14).padding(.vertical, 10)
                    .background(Color.neonPurple.opacity(0.15)).cornerRadius(8)
            } else {
                Button(action: onUpgrade) {
                    VStack(spacing: 2) {
                        Text("UPGRADE").font(.caption.bold())
                        Text("\(Upgrade.singularityLevelData[level].cost) ◈").font(.caption2)
                    }
                    .foregroundColor(canAfford ? .bgPrimary : .textMuted)
                    .padding(.horizontal, 14).padding(.vertical, 10)
                    .background(canAfford ? Color.neonPurple : Color.bgPrimary)
                    .cornerRadius(8)
                }
                .disabled(!canAfford)
            }
        }
        .padding(14).background(Color.bgCard).cornerRadius(12)
        .overlay(RoundedRectangle(cornerRadius: 12).stroke(borderColor, lineWidth: 1))
    }

    private func formatted(_ value: Double) -> String {
        value == value.rounded() ? "\(Int(value))" : String(format: "%.1f", value)
    }

    private var borderColor: Color {
        if isMaxed { return Color.neonPurple.opacity(0.5) }
        if level > 0 { return Color.neonPurple.opacity(0.25) }
        if canAfford { return Color.neonPurple.opacity(0.35) }
        return Color.clear
    }
}
