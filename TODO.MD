# TODO — Proof of Concept

## Goal

Build a playable idle game prototype with:
- tapping
- passive income
- upgrades
- save/load
- offline progression

The game should be fun within the first 5 minutes.

---

# Phase 1 — Project Setup ✅

- [x] Create SwiftUI iOS project
- [x] Create folder structure
- [x] Setup MVVM architecture
- [x] Create GameState model
- [x] Create Upgrade model
- [x] Create GameViewModel

---

# Phase 2 — Core Gameplay ✅

- [x] Add Compute resource
- [x] Add tap button
- [x] Add Compute per tap
- [x] Add passive income timer
- [x] Add Compute per second display
- [x] Add upgrade purchasing
- [x] Add upgrade ownership counts
- [x] Add scaling upgrade costs

---

# Phase 3 — Persistence ✅

- [x] Save game state locally
- [x] Load game state on startup
- [x] Track last active timestamp
- [x] Add offline earnings calculation

---

# Phase 4 — UI ✅

- [x] Add futuristic dark theme
- [x] Create stats header
- [x] Create upgrade row component
- [x] Add button feedback animations
- [x] Improve spacing/layout

---

# Phase 5 — Balancing

- [x] Ensure first upgrade buyable in under 20 seconds (GPU at 10 compute — ~5 taps)
- [x] Tune upgrade pricing (Server Rack 100→75, Data Centre 1000→500)
- [x] Extend upgrade ladder (added AI Cluster, Hyperscaler, Quantum Core)
- [ ] Play-test and verify progression feels rewarding
- [ ] Tune passive income pacing after play-testing

---

# Phase 6 — Polish

- [x] Add number abbreviations (compactFormatted)
- [x] Add offline earnings popup
- [x] Add sound placeholders (HapticManager — light on tap, success notification on purchase)
- [x] Add simple particle effects (floating "+X" label on tap)

---

# Not Yet

Do NOT add yet:
- [ ] Ads
- [ ] StoreKit
- [ ] Backend
- [ ] Multiplayer
- [ ] Cloud saves
- [ ] Analytics
- [ ] Achievements
- [ ] Prestige system

These come later after gameplay validation.
