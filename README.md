# Idle AI Empire

An iOS idle/incremental game built with SwiftUI.

The player starts with a tiny AI setup and gradually expands into a massive compute empire spanning global data centres, autonomous AI systems, and eventually planetary-scale infrastructure.

Inspired by classic incremental games, but with a modern AI/data-centre theme.

---

# Tech Stack

- SwiftUI + Swift
- MVVM architecture
- UserDefaults (JSON) persistence
- Combine for timers
- iOS-first, no external dependencies

---

# Core Gameplay

Players generate a resource called **Compute**.

They can:

- Tap to generate Compute instantly
- Buy upgrades (GPUs through Planetary Grid) for passive income
- Unlock Research nodes to apply permanent multipliers
- Earn Compute while offline or backgrounded (3h base, up to 16h with research)
- Prestige (Singularity) to reset upgrades and earn permanent shard multipliers

---

# Current State (2026-05-17)

## What works
- Tap button with spring-bounce animation + floating "+X" particle
- Haptic feedback on tap (light) and purchase/unlock (success notification)
- Passive income ticking 10× per second
- Auto-Tapper: unlocked at 25 GPUs, generates 1 tap/sec passively
- 12 buyable upgrades with ×1.15 scaling costs + ×5 milestone bonus per 100 owned
- Owned count badge + milestone badge (★ ×N) + total CPS + countdown to next milestone per upgrade
- Auto-save every 30 seconds + on background; offline earnings applied on both cold launch and foreground return
- Offline earnings popup on return
- Research system: 10 nodes purchased with Compute, permanent multipliers
- Prestige system: Singularity at 1T compute, shard multiplier (×1.1^shards) on all production
- 15 achievements with toast notifications and AWARDS screen
- UPGRADES / RESEARCH / AWARDS tab bar
- Dark futuristic UI (neon cyan + purple)

## Upgrades
| Name | Base Cost | Cost Multiplier | Compute/s each |
|------|-----------|-----------------|----------------|
| GPU | 10 | ×1.15 | 0.1 |
| Server Rack | 75 | ×1.15 | 0.5 |
| Data Centre | 500 | ×1.15 | 2.0 |
| AI Cluster | 4,000 | ×1.15 | 10.0 |
| Hyperscaler | 40,000 | ×1.15 | 50.0 |
| Quantum Core | 400,000 | ×1.15 | 250.0 |
| Cooling Array | 4,000,000 | ×1.15 | 1,250.0 |
| AI Agent | 40,000,000 | ×1.15 | 6,250.0 |
| Neural Fabric | 400,000,000 | ×1.15 | 31,250.0 |
| Orbital Station | 4,000,000,000 | ×1.15 | 156,250.0 |
| Dyson Swarm | 40,000,000,000 | ×1.15 | 781,250.0 |
| Planetary Grid | 400,000,000,000 | ×1.15 | 3,906,250.0 |

## Research Nodes (linear, purchased with Compute)
| Node | Cost | Effect |
|------|------|--------|
| Efficient Cooling | 1,500 | ×1.25 Compute/s |
| Parallel Processing | 12,000 | ×2 per tap |
| Neural Scaling | 120,000 | ×1.5 Compute/s |
| Edge Compute | 1,200,000 | +5h offline cap |
| Quantum Tunnelling | 12,000,000 | ×3 Compute/s |
| Singularity Protocol | 1,200,000,000 | ×2 Compute/s · ×2 per tap |
| Autonomous Replication | 12,000,000,000 | ×2 Compute/s |
| Deep Learning Array | 120,000,000,000 | ×3 per tap |
| Orbital Mesh | 1,200,000,000,000 | +8h offline cap |
| Planetary Consciousness | 12,000,000,000,000 | ×5 Compute/s |

All 10 nodes unlocked: ×112.5 CPS · ×12 per tap · 16h offline cap.

## Upgrade Milestones
Every 100 of an upgrade owned applies a ×5 multiplier to that upgrade's CPS (stacking):

| Owned | Multiplier | GPU example |
|-------|-----------|-------------|
| 100 | ×5 | 50/s |
| 200 | ×25 | 500/s |
| 300 | ×125 | 3,750/s |
| 400 | ×625 | 25,000/s |

Milestone multipliers stack on top of research and shard multipliers.

## Prestige
- Threshold: 1 Trillion Compute
- Award: 1 Singularity Shard per prestige
- Multiplier: ×1.1^shards applied to all Compute production
- Resets: upgrades + compute. Keeps: research nodes, shards

## Achievements (15)
Upgrade milestones, compute thresholds (1K → 1T), auto-tap, research, prestige. Toast on unlock.

## Not yet built
Real sound effects, visual polish, monetisation.

---

# Project Structure

```
IdleAIEmpire/
  App/
    IdleAIEmpireApp.swift         ← @main entry point
  Models/
    GameState.swift               ← Codable game data + all computed effective values
    Upgrade.swift                 ← Upgrade struct + 12-entry catalog
    ResearchNode.swift            ← ResearchNode struct + 10-entry catalog
    Achievement.swift             ← Achievement struct + 15-entry catalog
  ViewModels/
    GameViewModel.swift           ← ObservableObject, all game logic
  Views/
    ContentView.swift             ← Root screen + 3-tab bar + singularity banner + toast
    StatsHeaderView.swift         ← Compute counter + effective CPS + shard display
    TapButtonView.swift           ← Animated tap button + floating particle + auto ring
    UpgradesListView.swift        ← Scrollable upgrade list
    UpgradeRowView.swift          ← Single upgrade row + milestone badge + total CPS
    ResearchView.swift            ← Research node list
    AchievementsView.swift        ← Achievement list + AchievementToast
    SingularityView.swift         ← Prestige confirmation sheet
    OfflineEarningsView.swift     ← Offline earnings popup sheet
  Utilities/
    Theme.swift                   ← Color extensions
    NumberFormatting.swift        ← Double.compactFormatted (K/M/B/T/Q)
    PersistenceManager.swift      ← UserDefaults save/load
    HapticManager.swift           ← Haptic feedback (sound placeholder)
```

---

# Setup

1. Create a new Xcode project: **iOS App**, SwiftUI, Swift, named `IdleAIEmpire`
2. Delete the generated `ContentView.swift`
3. Drag the `IdleAIEmpire/` folder into the project navigator, checking **Add to target**
4. Replace the generated `IdleAIEmpireApp.swift` with the one from `App/`
5. Build and run on Simulator (iOS 16+)

---

# Completed Milestones

- [x] Tap button + spring animation + floating particle
- [x] Passive income (10 ticks/sec)
- [x] Upgrade purchasing (12 tiers, ×1.15 scaling)
- [x] Auto-Tapper (25 GPUs → 1 tap/sec passive)
- [x] Offline earnings + popup (cold launch + foreground return)
- [x] Save/load with forward migration for all catalogs
- [x] Futuristic dark UI (neon cyan + purple)
- [x] Haptics + tap particle
- [x] Research system (10 nodes, Compute cost, linear unlock)
- [x] Prestige / Singularity (shard multiplier, confirmation screen)
- [x] Achievements (15, toast on unlock, AWARDS screen)
- [x] Upgrade milestone bonuses (×5 per 100 owned, stacking)
- [x] PoC play-tested and validated
