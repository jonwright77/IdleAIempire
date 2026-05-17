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
- `GameState` is a **value type** (`struct`), not a class
- Upgrades are stored **inside** `GameState.upgrades` — this keeps save/load automatic
- `Upgrade.catalog` defines defaults for new games only; loaded saves use their own array
- Passive income uses a **0.1s Combine timer** (10 ticks/s for smooth display)
- Auto-save: every 30s + on `scenePhase == .background`
- Offline earnings: capped at **3 hours**, calculated at init
- Number display: `Double.compactFormatted` (K/M/B/T suffixes) — do NOT use `.formatted()` (conflicts with iOS 15 API)
- Colors: defined as `Color` extensions in `Utilities/Theme.swift`

## File map
```
App/IdleAIEmpireApp.swift
Models/GameState.swift
Models/Upgrade.swift
ViewModels/GameViewModel.swift
Views/ContentView.swift
Views/StatsHeaderView.swift
Views/TapButtonView.swift
Views/UpgradesListView.swift
Views/UpgradeRowView.swift
Utilities/Theme.swift
Utilities/NumberFormatting.swift
Utilities/PersistenceManager.swift
```

---

# MVP Requirements

The first playable build must include:

- [x] Compute resource
- [x] Tap generation
- [x] Passive income
- [x] Upgrade purchasing
- [x] Save/load
- [x] Offline earnings

No:
- ads
- analytics
- backend
- multiplayer
- cloud save
- StoreKit
- Game Center

---

# Adding Upgrades

Add new entries to `Upgrade.catalog` in `Models/Upgrade.swift`.

**Always append — never reorder** existing entries. The saved upgrade array aligns by index to the catalog.

---

# Current Phase

Phases 1–4 complete. Next: Phase 5 (balancing) — play-test, tune costs and pacing.
