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

## Key decisions (do not change without good reason)

**Resources & values**
- Single currency: `Compute`. Used for upgrades, research nodes, and prestige threshold.
- `GameState.computePerSecond` — raw CPS from upgrades only
- `GameState.effectiveComputePerSecond` — raw × research CPS multiplier × shard multiplier
- `GameState.effectiveComputePerTap` — base tap × research tap multiplier × shard multiplier
- `GameState.offlineCap` — 3h base + research offline bonuses (up to 16h)
- Passive income timer: **0.1s Combine timer** (10 ticks/s for smooth display)

**Upgrades**
- `GameState` is a **value type** (`struct`), not a class
- Upgrades stored inside `GameState.upgrades` — keeps save/load automatic
- `Upgrade.catalog` defines defaults for new games only; loaded saves use their own array
- **Never reorder catalog entries** — saved arrays align by index. Always append.
- `GameState.mergeNewCatalogEntries()` — called in `GameViewModel.init()` before offline earnings
- `Upgrade.milestones` = `owned / 100`; `milestoneMultiplier` = `pow(5.0, milestones)` — baked into `computePerSecond`. No stored state needed.

**Research**
- `ResearchNode.catalog` — 10 nodes, linear unlock (node N requires node N-1 unlocked)
- Nodes cost Compute (same currency as upgrades)
- Unlocking modifies `effectiveCPSMultiplier`, `effectiveTapMultiplier`, or `offlineCap`
- **Never reorder research catalog entries** — always append.
- `GameState.mergeNewResearchNodes()` — called in `GameViewModel.init()` before offline earnings

**Prestige (Singularity)**
- `GameState.singularityShards: Int` — persists across resets
- `GameState.shardMultiplier` — `pow(1.1, Double(singularityShards))`, applied to all compute
- `GameState.canPrestige` — true when `compute >= 1_000_000_000_000` (1T)
- `GameViewModel.performPrestige()` — increments shards, zeroes compute, resets all `upgrade.owned` to 0. Research nodes and shards are **kept**.

**Automation**
- `GameState.isAutoTapping` — computed from GPU owned count (`>= 25`). No stored state.
- Auto-tap adds `effectiveComputePerTap × tickRate` to compute each tick when active.

**Achievements**
- `Achievement.catalog` — 15 achievements. **Always append, never reorder.**
- `GameState.achievements: [Achievement]` — persisted, merged on load via `mergeNewAchievements()`
- `GameViewModel.checkAchievements()` — called every tick and after every state-changing action
- `GameViewModel.isUnlocked(_:)` — switch on `achievement.id`; add new cases when adding achievements
- Toast: `GameViewModel.toastAchievement` published for 3s, cleared by a `DispatchWorkItem`

**Persistence & background/foreground**
- Auto-save: every 30s + `handleBackground()` (sets `backgroundedAt`, calls `save()`)
- Cold launch offline earnings: calculated in `init()` from `state.lastSaveDate`
- Background→foreground earnings: calculated in `handleForeground()` from `backgroundedAt`; guard ensures it's a no-op on first launch
- All three `merge*()` functions must be called in `init()` before offline earnings are calculated

**Display**
- Number display: `Double.compactFormatted` (K/M/B/T/Q) — do NOT use `.formatted()` (iOS 15 conflict)
- Colors: `Color` extensions in `Utilities/Theme.swift`
- Neon cyan = upgrades/tap; neon purple = research/prestige; neon gold = milestone bonuses

## File map
```
App/IdleAIEmpireApp.swift
Models/GameState.swift
Models/Upgrade.swift
Models/ResearchNode.swift
Models/Achievement.swift
ViewModels/GameViewModel.swift
Views/ContentView.swift
Views/StatsHeaderView.swift
Views/TapButtonView.swift
Views/UpgradesListView.swift
Views/UpgradeRowView.swift
Views/ResearchView.swift
Views/AchievementsView.swift
Views/SingularityView.swift
Views/OfflineEarningsView.swift
Utilities/Theme.swift
Utilities/NumberFormatting.swift
Utilities/PersistenceManager.swift
Utilities/HapticManager.swift
```

---

# Adding Upgrades

Add new entries to `Upgrade.catalog` in `Models/Upgrade.swift`.

**Always append — never reorder.** The saved upgrade array aligns by index to the catalog.

---

# Adding Research Nodes

Add new entries to `ResearchNode.catalog` in `Models/ResearchNode.swift`.

**Always append — never reorder.** Same reason as upgrades.

Each node has: `cpsMultiplier`, `tapMultiplier`, `offlineHoursBonus`. Set unused fields to `1.0` / `0`.

---

# Adding Achievements

Add new entries to `Achievement.catalog` in `Models/Achievement.swift`.

**Always append — never reorder.** Same reason as upgrades.

Then add a matching `case` to `isUnlocked(_:)` in `GameViewModel.swift`.

---

# Current Phase

Phases 1–11 complete. Next: Phase 12 (Sound & Visual Polish).
