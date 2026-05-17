# TODO

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
- [x] Forward migration (new catalog entries merged into existing saves)

---

# Phase 4 — UI ✅

- [x] Add futuristic dark theme
- [x] Create stats header
- [x] Create upgrade row component
- [x] Add button feedback animations
- [x] Improve spacing/layout

---

# Phase 5 — Balancing ✅

- [x] Ensure first upgrade buyable in under 20 seconds (GPU at 10 compute — ~5 taps)
- [x] Tune upgrade pricing (Server Rack 100→75, Data Centre 1000→500)
- [x] Extend upgrade ladder to 12 tiers (GPU → Planetary Grid)
- [x] Play-test and verify progression feels rewarding
- [x] Tune passive income pacing

---

# Phase 6 — Polish ✅

- [x] Add number abbreviations (compactFormatted — K/M/B/T/Q)
- [x] Add offline earnings popup
- [x] Add sound placeholders (HapticManager — light tap, success on purchase)
- [x] Add particle effect (floating "+X" label on tap)

---

# Phase 7 — Validate PoC ✅

> "Would someone voluntarily keep playing this?"

- [x] Internal play-test: reach all 12 upgrades in a session
- [x] Verify first 5 minutes feel satisfying without explanation
- [x] Confirm no dead-time gaps in early progression
- [x] Decision: core loop is fun — proceed to Phase 8

---

# Phase 8 — Research System ✅

- [x] Add `ResearchNode` model with 10-node linear catalog
- [x] Research nodes purchased with Compute (same currency as upgrades)
- [x] Each node applies a permanent multiplier (CPS, tap, or offline cap)
- [x] Effective CPS/tap computed from base × research multipliers
- [x] Offline cap dynamic: 3h base + research bonuses (up to 16h)
- [x] Add UPGRADES / RESEARCH tab bar to UI
- [x] ResearchView: node list with lock/unlock/affordability states
- [x] Save/load via Codable; new nodes merged into existing saves

---

# Phase 9 — Automation ✅

The moment the game becomes truly idle. Players should feel their empire running without them.

- [x] Auto-Tapper unlocked after buying 25 GPUs (adds effectiveComputePerTap/sec to the tick)
- [x] Pulsing ring around tap button when active
- [x] "● AUTO" label below button when active

---

# Phase 10 — Prestige (Singularity) ✅

Core replayability. Resets feel like acceleration, not punishment.

- [x] Unlock Singularity at 1 Trillion compute
- [x] Reset upgrades and compute; keep research nodes and shards
- [x] Award 1 Singularity Shard per prestige — multiplier is ×1.1^shards on all compute
- [x] Show shards and multiplier in Stats header (purple, appears after first prestige)
- [x] Confirmation sheet: shows earnings, what's kept, what's reset
- [x] "SINGULARITY READY" banner appears in UI when threshold is met

---

# Phase 11 — Achievements ✅

Milestone markers that reward progress and give players a sense of history.

- [x] 15 achievements: upgrade milestones, compute thresholds (1K→1T), auto-tap, research, prestige
- [x] Persisted in GameState (Codable), merged on load like upgrades and research
- [x] Toast banner slides in from top on unlock (3s, success haptic)
- [x] AWARDS tab added to tab bar with full achievement list (locked shown at 45% opacity)

---

# Phase 12 — Sound & Visual Polish

Upgrade haptic placeholders to real audio. Add unlock moments and milestone fanfare.

- [ ] Add real tap sound via AVAudioPlayer (replace HapticManager stub)
- [ ] Add purchase sound effect
- [ ] Add upgrade row unlock animation (glow/pulse when first affordable)
- [ ] Add milestone fanfare: screen flash + stronger haptic on first prestige
- [ ] Add brief onboarding hint for first-time players (dismissible overlay)

---

# Phase 13 — Monetisation Foundation

Only start after Phase 10 is validated. Monetisation should enhance, never gate.

- [ ] Rewarded ad: ×2 compute for 30 seconds
- [ ] Remove Ads IAP (StoreKit)
- [ ] Cosmetic skins for tap button (no gameplay advantage)
- [ ] Audit every placement: would a player feel respected or exploited?

---

# Never

- [ ] Backend / multiplayer / cloud saves
- [ ] Aggressive interstitials
- [ ] Energy systems
- [ ] Paywalls
