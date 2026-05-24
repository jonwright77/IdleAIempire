# Idle AI Empire

An iOS idle/incremental game built with SwiftUI.

The player starts with a tiny AI setup on Neptune and gradually expands into a multi-planetary compute empire spanning the entire Solar System — from the outer ice giants all the way to the Sun itself.

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

Players generate a planet-specific resource called **Compute** (each planet has its own resource name).

They can:

- Tap to generate resource instantly
- Buy upgrades (12 tiers per planet) for passive income
- Unlock Research nodes (10 per planet) for permanent multipliers
- Earn resource while offline or backgrounded (3h base, up to 16h with research) — **all unlocked planets earn offline simultaneously**
- Prestige (Singularity) to reset upgrades on the current planet and earn permanent shard multipliers
- Unlock new planets by owning 100 of the final upgrade on the current planet

---

# Current State (2026-05-24)

## What works
- 9 playable planets: Neptune → Uranus → Saturn → Jupiter → Mars → Earth → Venus → Mercury → The Sun
- Per-planet accent colour themes throughout the UI
- Planet switcher bar at the top of the screen; Solar System selection sheet
- Unlock next planet banner when 100 of the final upgrade is owned
- All unlocked planets earn offline simultaneously
- Shards are per-planet (independent prestige economies)
- Tap button with spring-bounce animation + floating "+X" particle
- Haptic feedback on tap (light) and purchase/unlock (success notification)
- Passive income ticking 10× per second on the active planet
- Auto-Tapper: unlocked at 25 of the first upgrade on each planet
- 12 buyable upgrades per planet with ×1.15 scaling costs + ×5000 milestone bonus per 100 owned
- 10 research nodes per planet, linear unlock, permanent multipliers
- Prestige / Singularity per planet: shard multiplier (×1.1^shards) on all production
- 17 achievements (including planet unlock milestones) with toast notifications
- UPGRADES / RESEARCH / ASCEND / AWARDS tab bar
- Dark futuristic UI with per-planet neon accent colours

## Planets

| # | Planet | Resource | Accent | Unlock Condition |
|---|--------|----------|--------|-----------------|
| 1 | Neptune | Compute | Cyan | Starting planet |
| 2 | Uranus | Ice Flux | Ice Teal | 100× Planetary Grid |
| 3 | Saturn | Ring Data | Amber | 100× Ice Giant Matrix |
| 4 | Jupiter | Storm Data | Deep Orange | 100× Ring Sovereign |
| 5 | Mars | Dust Data | Rust Red | 100× Great Storm Sovereign |
| 6 | Earth | Net Data | Ocean Blue | 100× Red World Matrix |
| 7 | Venus | Heat Flux | Sulfur Yellow | 100× World Brain |
| 8 | Mercury | Solar Data | Silver | 100× Venusian Sovereign |
| 9 | The Sun | Stellar Flux | Gold | 100× Mercury Sovereign |

## Neptune Upgrades
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

Each subsequent planet is ×50 more expensive with proportionally higher CPS, maintaining similar time-to-complete per planet.

## Research Nodes (10 per planet, linear unlock)
All planets share the same effect structure:

| Position | Effect |
|----------|--------|
| 1 | ×1.25 Resource/s |
| 2 | ×2,000 per tap |
| 3 | ×1.5 Resource/s |
| 4 | +5h offline cap |
| 5 | ×3 Resource/s |
| 6 | ×2 Resource/s + ×2,000 per tap |
| 7 | ×2 Resource/s |
| 8 | ×3,000 per tap |
| 9 | +8h offline cap |
| 10 | ×5 Resource/s |

All 10 unlocked: ×112.5 CPS · ×12,000 per tap · 16h offline cap (per planet).

## Upgrade Milestones
Every 100 of an upgrade owned applies a ×5000 multiplier to that upgrade's CPS (stacking):

| Owned | Multiplier |
|-------|-----------|
| 100 | ×5,000 |
| 200 | ×25,000,000 |
| 300 | ×125,000,000,000 |

## Prestige (Singularity)
Each planet has its own prestige economy:
- Threshold scales ×50 per planet (Neptune: 1T → Sun: ~39 Sp)
- Award: 1 Singularity Shard per prestige (per planet)
- Multiplier: ×1.1^shards applied to all production on that planet
- Resets: upgrades + compute. Keeps: research nodes, shards

## Number Formatting
| Suffix | Value |
|--------|-------|
| K | 10³ |
| M | 10⁶ |
| B | 10⁹ |
| T | 10¹² |
| Q | 10¹⁵ |
| Qi | 10¹⁸ |
| Sx | 10²¹ |
| Sp | 10²⁴ |
| Oc | 10²⁷ |
| No | 10³⁰ |
| Dc | 10³³ |

## Achievements (17)
Upgrade milestones, compute thresholds (1K → 1T), auto-tap, research, prestige, planet unlocks. Toast on unlock.

## Not yet built
Real sound effects, visual polish, monetisation.

---

# Project Structure

```
IdleAIEmpire/
  App/
    IdleAIEmpireApp.swift         ← @main entry point
  Models/
    GameState.swift               ← Codable top-level state: [PlanetBoard] + activePlanetIndex + achievements
    PlanetBoard.swift             ← Per-planet Codable state + all computed effective values
    PlanetDefinition.swift        ← Static catalog data for all 9 planets (upgrades, research, colors)
    Upgrade.swift                 ← Upgrade struct + Neptune catalog
    ResearchNode.swift            ← ResearchNode struct + Neptune catalog
    Achievement.swift             ← Achievement struct + 17-entry catalog
  ViewModels/
    GameViewModel.swift           ← ObservableObject, all game logic via activePlanet
  Views/
    ContentView.swift             ← Root: planet switcher bar + tab bar + banners + toast
    StatsHeaderView.swift         ← Resource counter + effective CPS + shard display (planet-themed)
    TapButtonView.swift           ← Animated tap button + floating particle + auto ring
    UpgradesListView.swift        ← Scrollable upgrade list (active planet)
    UpgradeRowView.swift          ← Single upgrade row + milestone badge + total CPS
    ResearchView.swift            ← Research node list (active planet)
    AchievementsView.swift        ← Achievement list + AchievementToast
    SingularityView.swift         ← Prestige confirmation sheet (planet-flavoured)
    SingularityUpgradesView.swift ← Singularity point upgrades (active planet)
    PlanetSelectView.swift        ← Solar System planet picker sheet
    OfflineEarningsView.swift     ← Offline earnings popup sheet
  Utilities/
    Theme.swift                   ← Color extensions + per-planet accent colors + PlanetAccentKey env
    NumberFormatting.swift        ← Double.compactFormatted (K → Dc)
    PersistenceManager.swift      ← UserDefaults save/load
    HapticManager.swift           ← Haptic feedback
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
- [x] Auto-Tapper (25 of first upgrade → 1 tap/sec passive)
- [x] Offline earnings + popup (cold launch + foreground return, all planets)
- [x] Save/load with forward migration for all catalogs and planet boards
- [x] Futuristic dark UI with per-planet neon accent colours
- [x] Haptics + tap particle
- [x] Research system (10 nodes per planet, Compute cost, linear unlock)
- [x] Prestige / Singularity per planet (shard multiplier, confirmation screen)
- [x] Achievements (17, toast on unlock, AWARDS screen)
- [x] Upgrade milestone bonuses (×5000 per 100 owned, stacking)
- [x] Multi-planet system (9 planets, sequential unlock, per-planet economies)
- [x] Extended number formatting (K → Dc, handles numbers to 10³³+)
- [x] Planet Select screen with lock/progress state
- [x] Planet-themed UI accent colours via SwiftUI environment
