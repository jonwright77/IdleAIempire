# Idle AI Empire — Vision

---

# Current Milestone (2026-05-24)

**Status:** Phases 1–13 complete.

What's built:
- 9 planets: Neptune → Uranus → Saturn → Jupiter → Mars → Earth → Venus → Mercury → The Sun
- 12 upgrade tiers per planet (GPU → Planetary Grid on Neptune; planet-themed names elsewhere)
- 10 research nodes per planet with permanent multipliers (CPS, tap, offline cap)
- Auto-Tapper (25 of first upgrade → passive tap/sec, pulsing ring UI)
- Prestige / Singularity per planet (shard multiplier ×1.1^shards, planet-flavoured names)
- 17 achievements with toast notifications and AWARDS screen
- Offline earnings for all unlocked planets simultaneously (up to 16h each)
- Per-planet accent colour themes via SwiftUI environment injection
- Planet switcher bar + Solar System selection sheet
- Extended number formatting: K → Dc (handles numbers to 10³³+)
- UPGRADES / RESEARCH / ASCEND / AWARDS tab UI

Next: Phase 14 (Monetisation Foundation).

---

# Core Fantasy

The player starts with a weak AI setup in a garage.

Over time they evolve into the owner of the largest compute empire in existence.

The fantasy is:
- infinite scale
- technological acceleration
- automation
- exponential growth
- becoming absurdly powerful

The player should constantly feel:
> "My empire is growing faster and faster."

---

# Pillars

## 1. Satisfying Progression

Every interaction should:
- increase numbers
- unlock systems
- create momentum
- reward optimisation

The game should avoid:
- dead time
- confusing mechanics
- excessive friction

---

## 2. Strong Theme

This is NOT a generic clicker game.

The theme should feel:
- modern
- tech-focused
- AI-inspired
- slightly satirical
- visually futuristic

Possible tone:
- corporate AI absurdity
- startup culture parody
- runaway technological growth

---

## 3. Layered Growth

Progression should evolve in layers.

### Early Game ✅
- GPUs, Server Racks, Data Centres
- manual tapping
- research unlocks early multipliers

### Mid Game ✅
- AI Clusters, Hyperscalers, Quantum Cores
- Cooling Arrays, AI Agents, Neural Fabric
- research tree with CPS + tap multipliers
- Auto-Tapper milestone

### Late Game ✅
- Orbital Stations, Dyson Swarms, Planetary Grid
- top research nodes: Autonomous Replication → Planetary Consciousness
- Prestige / Singularity resets with shard multiplier

### Endgame ✅
- 9 planets spanning the Solar System (Neptune → Sun)
- Planet-specific economies: own upgrades, research, prestige, accent colours
- Sequential unlock (100 of final upgrade on current planet)
- All unlocked planets earn offline simultaneously
- Extended number range: K → Dc (10³³+)

### Systems still to build
- Real sound effects (Phase 12 partial — hooks exist, audio files not added)
- Monetisation (Phase 14)

---

# Long-Term Systems

| System | Status |
|--------|--------|
| Research tree | ✅ Built (10 nodes per planet) |
| Automation / auto-tap | ✅ Built (25 of first upgrade per planet) |
| Prestige / Singularity resets | ✅ Built (per-planet, shard multiplier) |
| Achievements | ✅ Built (17 achievements, toast) |
| Multi-planet expansion | ✅ Built (9 planets, Neptune → Sun) |
| Per-planet colour themes | ✅ Built (SwiftUI environment injection) |
| Sound & visual polish | Phase 12 (haptics done; audio files pending) |
| Rewarded ads | Phase 14 |
| Cosmetic upgrades | Phase 14 |
| Remove Ads IAP | Phase 14 |
| Daily rewards | Future |
| Events / limited-time boosts | Future |
| Global leaderboard | Future (maybe never) |

---

# Monetisation Philosophy

Phase 13 is complete — monetisation can now be planned and built (Phase 14).

Monetisation should:
- enhance progression
- never feel hostile
- respect player time

Preferred:
- rewarded ads (×2 compute for 30s)
- optional boosts
- cosmetic purchases
- remove ads purchase

Avoid:
- aggressive interstitials
- paywalls
- energy systems
- predatory mechanics

---

# Visual Direction

Style:
- dark UI
- neon accents (per-planet accent colour — cyan for Neptune; purple = research/prestige across all planets)
- glowing stats
- futuristic dashboards
- clean monospaced typography

Inspirations:
- sci-fi control rooms
- AI server racks
- cyberpunk interfaces
- modern SaaS dashboards

---

# Success Criteria

The project succeeds if:

1. The game is satisfying to play repeatedly
2. Players return daily
3. Session length increases over time
4. Monetisation feels natural
5. The game can scale with additional content
