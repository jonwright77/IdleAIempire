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
- Single resource: `Compute`. Research nodes are also purchased with Compute.
- `GameState.computePerSecond` — raw CPS from upgrades only
- `GameState.effectiveComputePerSecond` — raw × research CPS multipliers (use this for gameplay)
- `GameState.effectiveComputePerTap` — base tap × research tap multipliers
- `GameState.offlineCap` — 3h base + offline hours bonus from research nodes (up to 16h)
- Passive income timer: **0.1s Combine timer** (10 ticks/s for smooth display)

**Upgrades**
- `GameState` is a **value type** (`struct`), not a class
- Upgrades stored inside `GameState.upgrades` — keeps save/load automatic
- `Upgrade.catalog` defines defaults for new games only; loaded saves use their own array
- **Never reorder catalog entries** — saved arrays align by index. Always append new entries.
- `GameState.mergeNewCatalogEntries()` — call on load to append any new catalog entries

**Research**
- `ResearchNode.catalog` — 10 nodes, linear unlock (node N requires node N-1)
- Nodes cost Compute (same currency as upgrades)
- Unlocking a node permanently modifies `effectiveCPSMultiplier`, `effectiveTapMultiplier`, or `offlineCap`
- **Never reorder research catalog entries** — same reason as upgrades. Always append.
- `GameState.mergeNewResearchNodes()` — call on load alongside `mergeNewCatalogEntries()`

**Persistence & save migration**
- Auto-save: every 30s + on `scenePhase == .background`
- Offline earnings: capped by `offlineCap`, calculated at init using `effectiveComputePerSecond`
- Both `mergeNewCatalogEntries()` and `mergeNewResearchNodes()` must be called in `GameViewModel.init()` before offline earnings are calculated

**Display**
- Number display: `Double.compactFormatted` (K/M/B/T/Q suffixes) — do NOT use `.formatted()` (conflicts with iOS 15 API)
- Colors: defined as `Color` extensions in `Utilities/Theme.swift`
- Neon cyan = upgrades; neon purple = research

## File map
```
App/IdleAIEmpireApp.swift
Models/GameState.swift
Models/Upgrade.swift
Models/ResearchNode.swift
ViewModels/GameViewModel.swift
Views/ContentView.swift
Views/StatsHeaderView.swift
Views/TapButtonView.swift
Views/UpgradesListView.swift
Views/UpgradeRowView.swift
Views/ResearchView.swift
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

# Current Phase

Phases 1–8 complete. Next: Phase 9 (Automation).
