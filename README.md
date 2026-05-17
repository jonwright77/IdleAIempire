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
- Earn Compute while offline (3h base, up to 16h with research)

---

# Current State (2026-05-17)

## What works
- Tap button with spring-bounce animation + floating "+X" particle
- Haptic feedback on tap (light) and purchase (success notification)
- Passive income ticking 10× per second
- 12 buyable upgrades with ×1.15 scaling costs
- Owned count badge per upgrade
- Auto-save every 30 seconds + on app background
- Offline earnings calculated on next launch + popup on return
- Research system: 10 nodes purchased with Compute, permanent multipliers
- UPGRADES / RESEARCH tab bar (neon cyan / neon purple accents)
- Dark futuristic UI

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

## Not yet built
Automation, prestige, achievements, real sound effects.

---

# Project Structure

```
IdleAIEmpire/
  App/
    IdleAIEmpireApp.swift         ← @main entry point
  Models/
    GameState.swift               ← Codable game data + effective value computed props
    Upgrade.swift                 ← Upgrade struct + 12-entry catalog
    ResearchNode.swift            ← ResearchNode struct + 10-entry catalog
  ViewModels/
    GameViewModel.swift           ← ObservableObject, all game logic
  Views/
    ContentView.swift             ← Root screen + UPGRADES/RESEARCH tab bar
    StatsHeaderView.swift         ← Compute counter + effective CPS
    TapButtonView.swift           ← Animated tap button + floating particle
    UpgradesListView.swift        ← Scrollable upgrade list
    UpgradeRowView.swift          ← Single upgrade row
    ResearchView.swift            ← Research node list
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

- [x] Tap button
- [x] Passive income
- [x] Upgrade purchasing (12 tiers)
- [x] Offline earnings + popup
- [x] Save/load system with forward migration
- [x] Futuristic dark UI (neon cyan + purple)
- [x] Haptics + tap particle effect
- [x] Research system (10 nodes, linear unlock, Compute cost)
- [x] PoC play-tested and validated
