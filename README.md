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
- Buy upgrades (GPUs, Server Racks, Data Centres) for passive income
- Earn Compute while offline (up to 3 hours)

---

# Current State (PoC — 2026-05-17)

## What works
- Tap button with spring-bounce animation
- Passive income ticking 10× per second
- 6 buyable upgrades with scaling costs
- Owned count badge per upgrade
- Auto-save every 30 seconds + on app background
- Offline earnings calculated on next launch + popup on return
- Dark futuristic UI with neon cyan accents

## Upgrades
| Name | Base Cost | Cost Multiplier | Compute/s each |
|------|-----------|-----------------|----------------|
| GPU | 10 | ×1.15 | 0.1 |
| Server Rack | 75 | ×1.15 | 0.5 |
| Data Centre | 500 | ×1.15 | 2.0 |
| AI Cluster | 4,000 | ×1.15 | 10.0 |
| Hyperscaler | 40,000 | ×1.15 | 50.0 |
| Quantum Core | 400,000 | ×1.15 | 250.0 |

## Not yet built
Sound, particle effects, prestige, research, achievements.

---

# Project Structure

```
IdleAIEmpire/
  App/
    IdleAIEmpireApp.swift       ← @main entry point
  Models/
    GameState.swift             ← Codable game data struct
    Upgrade.swift               ← Upgrade struct + catalog
  ViewModels/
    GameViewModel.swift         ← ObservableObject, all game logic
  Views/
    ContentView.swift           ← Root screen
    StatsHeaderView.swift       ← Compute counter + CPS
    TapButtonView.swift         ← Animated tap button
    UpgradesListView.swift      ← Scrollable upgrade list
    UpgradeRowView.swift        ← Single upgrade row
  Utilities/
    Theme.swift                 ← Color extensions
    NumberFormatting.swift      ← Double.compactFormatted
    PersistenceManager.swift    ← UserDefaults save/load
```

---

# Setup

1. Create a new Xcode project: **iOS App**, SwiftUI, Swift, named `IdleAIEmpire`
2. Delete the generated `ContentView.swift`
3. Drag the `IdleAIEmpire/` folder into the project navigator, checking **Add to target**
4. Replace the generated `IdleAIEmpireApp.swift` with the one from `App/`
5. Build and run on Simulator (iOS 16+)

---

# MVP Goals

- [x] Tap button
- [x] Passive income
- [x] Upgrade purchasing
- [x] Offline earnings
- [x] Save/load system
- [x] Basic futuristic UI
- [x] Balancing pass (upgrade tuning + extended ladder)
- [x] Offline earnings popup
- [ ] Play-test and final tune

The goal is to validate:
> "Is the core gameplay loop satisfying?"
