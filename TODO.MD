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

# Phase 9 — Automation

The moment the game becomes truly idle. Players should feel their empire running without them.

- [ ] Add Auto-Tapper milestone: unlocked after buying 25 GPUs (generates 1 tap/sec)
- [ ] Show automation status in the UI (pulsing indicator when active)
- [ ] Optionally: make Auto-Tapper upgradeable via Research

---

# Phase 10 — Prestige (Singularity)

Core replayability. Resets feel like acceleration, not punishment.

- [ ] Unlock Singularity option after reaching a compute threshold (e.g. 1 Trillion)
- [ ] Reset upgrades and compute on prestige
- [ ] Award `Singularity Shards` — permanent per-run multiplier (×1.1 per shard)
- [ ] Show Singularity Shards and current multiplier in Stats header
- [ ] Add prestige confirmation screen (show what you'll earn and keep)
- [ ] Balance: first prestige should be reachable in ~30–60 mins of play

---

# Phase 11 — Achievements

Milestone markers that reward progress and give players a sense of history.

- [ ] Define ~15 achievements (first GPU, first passive income, first prestige, 1K/1M/1B compute, etc.)
- [ ] Add `AchievementManager` to track and persist unlocks
- [ ] Show a toast notification on unlock (brief banner, distinct haptic)
- [ ] Add Achievements screen accessible from UI

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
