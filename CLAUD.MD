# Claude Code Instructions

You are helping build an iOS idle/incremental game called **Idle AI Empire**.

Read VISION.MD, TODO.MD, and README.md before making major architectural decisions.

---

# High-Level Goals

Prioritise:
1. Simplicity
2. Fast iteration
3. Playability
4. Maintainable code

Avoid:
- overengineering
- unnecessary abstractions
- premature optimisation
- backend systems
- complex dependency injection

---

# Tech Requirements

Use:
- SwiftUI
- Swift
- MVVM architecture
- UserDefaults + JSON for persistence
- Combine for timers
- Native iOS frameworks only

No external dependencies.

---

# Coding Style

Prefer:
- small, focused files
- readable naming
- simple logic
- comments only when the WHY is non-obvious

Avoid:
- deeply nested logic
- large god objects
- unnecessary protocols
- overcomplicated generics
- comments that describe WHAT (let the code do that)

---

# Gameplay Priorities

Gameplay feel is more important than architecture purity.

The core loop should feel:
- responsive
- rewarding
- fast
- satisfying

---

# Architecture

## Pattern
MVVM. `GameViewModel` is the single `ObservableObject`. Views observe it with `@ObservedObject`.

## Key Concepts

### Multi-Planet System
The game has 9 planets, each a self-contained idle game board.

- `GameState` holds `planets: [PlanetBoard]`, `activePlanetIndex: Int`, and global `achievements: [Achievement]`
- `PlanetBoard` holds all per-planet state: compute, upgrades, researchNodes, singularity data, lastSaveDate
- `PlanetDefinition` (static, not Codable) holds the catalog for each planet: upgrades, research, accent colour, resource name, singularity name
- `GameViewModel.activePlanet` — get/set shortcut to `state.planets[state.activePlanetIndex]`
- `GameViewModel.activePlanetDefinition` — shortcut to `PlanetDefinition.all[state.activePlanetIndex]`
- All actions (tap, buyUpgrade, unlockResearch, performPrestige, etc.) operate on the active planet
- All unlocked planets earn offline simultaneously (each uses its own `lastSaveDate`)

### Planet Order
`PlanetDefinition.all` is ordered: Neptune, Uranus, Saturn, Jupiter, Mars, Earth, Venus, Mercury, Sun.
**Never reorder this array** — indexes must align with saved `[PlanetBoard]`.

### Planet Unlock
- Condition: `(activePlanet.upgrades.last?.owned ?? 0) >= 100`
- `GameViewModel.canUnlockNextPlanet` — computed property
- `GameViewModel.unlockNextPlanet()` — sets `state.planets[nextIndex].unlocked = true`
- ContentView shows an "Unlock Next Planet" banner when condition is met

### Per-Planet Accent Colour
- Each `PlanetDefinition` has an `accentColor: Color`
- ContentView injects it via `.environment(\.planetAccent, accent)`
- Views read it with `@Environment(\.planetAccent) var accent`
- The `PlanetAccentKey` environment key is defined in `Utilities/Theme.swift`

### Resources & Values (per planet)
- `PlanetBoard.computePerSecond` — raw CPS from upgrades only
- `PlanetBoard.effectiveComputePerSecond` — raw × research CPS multiplier × shard multiplier
- `PlanetBoard.effectiveComputePerTap` — base tap × research tap multiplier × shard multiplier
- `PlanetBoard.offlineCap` — 3h base + research offline bonuses (up to 16h)
- `GameViewModel.canPrestige` — computed from active planet's compute vs `PlanetDefinition.singularityThreshold`
- Passive income timer: **0.1s Combine timer** (10 ticks/s for smooth display)

### Upgrades (per planet)
- Each planet's upgrades are stored in `PlanetBoard.upgrades`
- `Upgrade.catalog` (on `Upgrade.swift`) defines Neptune's upgrades; other planets defined in `PlanetDefinition`
- `PlanetBoard.mergeUpgrades(catalog:)` — called in `GameState.mergeAll()` at launch
- **Never reorder a planet's upgrade catalog** — saved arrays align by index. Always append.
- `Upgrade.milestones` = `owned / 100`; `milestoneMultiplier` = `pow(5000.0, milestones)` — baked into `computePerSecond`

### Research (per planet)
- Each planet has 10 research nodes stored in `PlanetBoard.researchNodes`
- `ResearchNode.catalog` (on `ResearchNode.swift`) defines Neptune's research; others in `PlanetDefinition`
- `PlanetBoard.mergeResearch(catalog:)` — called in `GameState.mergeAll()` at launch
- Nodes cost the planet's own resource; linear unlock (node N requires N-1)
- **Never reorder a planet's research catalog** — always append.

### Prestige (Singularity) — per planet
- `PlanetBoard.singularityShards: Int` — persists across resets on that planet only
- `PlanetBoard.shardMultiplier` — `pow(1.1, Double(singularityShards))`, applied to all compute on that planet
- `GameViewModel.canPrestige` — true when `activePlanet.compute >= activePlanetDefinition.singularityThreshold`
- `GameViewModel.performPrestige()` — increments shards, zeroes compute, resets all `upgrade.owned` to 0, resets research nodes
- Singularity name is per-planet (e.g. "Ice Collapse" on Uranus, "Ring Collapse" on Saturn)

### Automation
- `PlanetBoard.isAutoTapping` — computed from first upgrade owned count (`>= 25`)
- Auto-tap adds `effectiveComputePerTap × tickRate` to compute each tick when active

### Achievements (global)
- `Achievement.catalog` — 17 achievements. **Always append, never reorder.**
- `GameState.achievements: [Achievement]` — persisted, merged on load via `mergeNewAchievements()`
- `GameViewModel.checkAchievements()` — called every tick and after every state-changing action
- `GameViewModel.isUnlocked(_:)` — switch on `achievement.id`; add new cases when adding achievements
- Toast: `GameViewModel.toastAchievement` published for 3s, cleared by a `DispatchWorkItem`

### Persistence & background/foreground
- Auto-save: every 30s + `handleBackground()` (sets `backgroundedAt`, calls `save()`)
- `save()` sets `lastSaveDate = Date()` on ALL planets
- Cold launch offline earnings: `GameState.applyOfflineEarnings()` in `init()` uses each planet's own `lastSaveDate`
- Background→foreground: `handleForeground()` uses `backgroundedAt` for all planets; shows popup for active planet only
- `GameState.mergeAll()` must be called in `init()` before offline earnings are applied

### Save Migration
Old saves (pre-multi-planet) have flat top-level keys (compute, upgrades, etc.).
`GameState.init(from:)` detects absence of the `planets` key and reconstructs Neptune's `PlanetBoard` from the legacy fields.

### Display
- Number display: `Double.compactFormatted` (K/M/B/T/Q/Qi/Sx/Sp/Oc/No/Dc) — do NOT use `.formatted()` (iOS 15 conflict)
- Colors: `Color` extensions in `Utilities/Theme.swift`; per-planet colors: `.planetNeptune` → `.planetSun`
- Active planet accent colour via `@Environment(\.planetAccent)` — set in `ContentView`
- Purple = research/prestige (consistent across all planets)

## File map
```
App/IdleAIEmpireApp.swift
Models/GameState.swift               ← [PlanetBoard] + activePlanetIndex + achievements
Models/PlanetBoard.swift             ← Per-planet Codable state + computed effective values
Models/PlanetDefinition.swift        ← Static catalogs for all 9 planets
Models/Upgrade.swift                 ← Upgrade struct + Neptune upgrade catalog
Models/ResearchNode.swift            ← ResearchNode struct + Neptune research catalog
Models/Achievement.swift             ← Achievement struct + 17-entry global catalog
ViewModels/GameViewModel.swift       ← All game logic, operates on activePlanet
Views/ContentView.swift              ← Root: planet switcher + tab bar + banners + toast
Views/StatsHeaderView.swift          ← Resource counter + CPS + shard display
Views/TapButtonView.swift            ← Animated tap button + floating particle + auto ring
Views/UpgradesListView.swift         ← Upgrade list (active planet)
Views/UpgradeRowView.swift           ← Single upgrade row
Views/ResearchView.swift             ← Research node list (active planet)
Views/AchievementsView.swift         ← Achievement list + toast
Views/SingularityView.swift          ← Prestige confirmation sheet
Views/SingularityUpgradesView.swift  ← Singularity point upgrades (active planet)
Views/PlanetSelectView.swift         ← Solar System picker sheet
Views/OfflineEarningsView.swift      ← Offline earnings popup
Utilities/Theme.swift                ← Color extensions + planet colors + PlanetAccentKey env
Utilities/NumberFormatting.swift     ← Double.compactFormatted (K → Dc)
Utilities/PersistenceManager.swift   ← UserDefaults save/load
Utilities/HapticManager.swift        ← Haptic feedback
```

---

# Adding a New Planet

1. Add a new `static let` entry to `PlanetDefinition` in `Models/PlanetDefinition.swift`
2. Append it to `PlanetDefinition.all` (never reorder — indexes align with saved planet array)
3. Define 12 upgrades and 10 research nodes (follow the established cost/CPS scaling pattern)
4. Add the planet's accent color to `Utilities/Theme.swift`
5. `GameState.mergeAll()` will automatically append the new planet board on next launch

---

# Adding Upgrades to a Planet

Add new entries to the end of that planet's `upgradeCatalog` in `PlanetDefinition.swift` (or `Upgrade.catalog` for Neptune).

**Always append — never reorder.** The saved upgrade array aligns by index to the catalog.

---

# Adding Research Nodes to a Planet

Add new entries to the end of that planet's `researchCatalog` in `PlanetDefinition.swift` (or `ResearchNode.catalog` for Neptune).

**Always append — never reorder.** Same reason as upgrades.

Each node has: `cpsMultiplier`, `tapMultiplier`, `offlineHoursBonus`. Set unused fields to `1.0` / `0`.

---

# Adding Achievements

Add new entries to `Achievement.catalog` in `Models/Achievement.swift`.

**Always append — never reorder.** Same reason as upgrades.

Then add a matching `case` to `isUnlocked(_:)` in `GameViewModel.swift`.

---

# Monthly Events System

Events are a parallel progression system separate from planets, unlocked after the second planet (Uranus).

## Key Architecture
- `EventDefinition` (static) — like `PlanetDefinition`, holds catalog for each event. **Never reorder `all` array.**
- `EventBoard` (Codable) — like `PlanetBoard`, holds mutable state. Key difference: `shardMultiplier = pow(1.5, Double(singularityShards))`
- `GameState.events: [EventBoard]` + `GameState.gems: Int` — persisted alongside planets
- `GameViewModel.activeEvent` / `activeEventDefinition` — shortcuts to `state.events[0]`
- Event actions: `tapEvent()`, `buyEventUpgrade(id:)`, `buyEventUpgradeToMilestone(id:)`, `performEventPrestige()`, `buyEventSingularityUpgrade(upgradeId:)`, `unlockEventResearch(id:)`
- `checkEventUnlocks()` — called each tick; unlocks June event when `planets[1].unlocked`
- Events earn offline (included in `applyOfflineEarnings` and `handleForeground`)
- Events tick passively in the main timer regardless of which view is open

## Gems
- `GameState.gems: Int` — global currency
- Earned: 50 gems at owned==500, 100 gems at owned==1000 per upgrade, both planet and event boards
- Tracked per-board via `gemMilestonesEarned: Set<String>` (key: `"upgradeId_500"`)
- `PlanetBoard.gemMilestonesEarned` — needs custom Codable (field absent from old saves)
- Gem shop TBD

## Event Board UI
- `EventBoardView` — full-screen sheet opened from the event banner in ContentView
- `EventDefinition.all` is ordered; always append new months, never reorder
- June event: "Midsummer Bloom", 12 upgrades, 15 research nodes, threshold 1e8, shard base 1.5

## File Map (additions)
```
Models/EventBoard.swift        ← mutable event state (shard base 1.5)
Models/EventDefinition.swift   ← static event catalogs (June = june)
Views/EventBoardView.swift     ← full event board UI (tap, upgrades, research, ascend)
```

## Adding a New Monthly Event
1. Add a `static let monthName` to `EventDefinition` (in `EventDefinition.swift`)
2. Append to `EventDefinition.all` (never reorder)
3. Add the event's accent color to `Theme.swift`
4. Update `checkEventUnlocks()` in `GameViewModel` for the new event's unlock condition
5. `GameState.mergeAll()` will auto-append the new EventBoard on next launch

---

# Current Phase

Phases 1–13 complete. Phase 14: Monthly Events (June proof of concept complete) + Gem Shop TBD.
