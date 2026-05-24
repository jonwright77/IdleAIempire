# Multi-Planet Feature — Design Specification

## Overview

Add 8 new game boards (planets) beyond the existing Neptune board, plus a final Sun board, for 9 total. Each board is a self-contained idle game with its own resource, upgrades, research tree, and singularity (prestige) mechanic. Boards unlock sequentially from furthest planet to nearest, ending at the Sun.

**Planet order (unlock order):**
1. Neptune ← existing board, starting planet
2. Uranus
3. Saturn
4. Jupiter
5. Mars
6. Earth
7. Venus
8. Mercury
9. Sun ← final board

**Unlock condition:** Own 100 of the 12th (final) upgrade on a planet to unlock the next one.

---

## Architecture

### New Model: `PlanetBoard` (Codable)

Replaces the per-game fields currently spread across `GameState`. One `PlanetBoard` per planet.

```swift
struct PlanetBoard: Codable, Identifiable {
    let id: String                              // "neptune", "uranus", etc.
    var unlocked: Bool
    var compute: Double                         // the planet's own resource
    var computePerTap: Double                   // base = 1
    var upgrades: [Upgrade]
    var researchNodes: [ResearchNode]
    var singularityShards: Int
    var singularityPoints: Int
    var singularityUpgradeLevels: [String: Int]
    var lastSaveDate: Date

    // Computed: effectiveCPSMultiplier, effectiveTapMultiplier,
    //           offlineCap, shardMultiplier, canPrestige,
    //           effectiveComputePerSecond, effectiveComputePerTap,
    //           isAutoTapping
    // Mutating: mergeUpgrades(), mergeResearch()
}
```

All computed properties and merge methods currently on `GameState` move here, unchanged in logic.

### New Model: `PlanetDefinition` (static, not Codable)

Pure static data. Not persisted. Provides the catalog for each planet.

```swift
struct PlanetDefinition {
    let id: String
    let name: String
    let emoji: String
    let accentColorHex: String          // used in Theme
    let resourceName: String            // displayed as "COMPUTE", "ICE FLUX", etc.
    let singularityThreshold: Double
    let singularityThresholdLabel: String  // e.g. "1 Trillion"
    let upgradeCatalog: [Upgrade]
    let researchCatalog: [ResearchNode]

    static let all: [PlanetDefinition]  // ordered Neptune → Sun
}
```

### Updated `GameState`

```swift
struct GameState: Codable {
    var planets: [PlanetBoard]         // index matches PlanetDefinition.all
    var activePlanetIndex: Int
    var achievements: [Achievement]    // still global
}
```

**Migration:** The backwards-compatible decoder constructs `planets[0]` (Neptune) from the old flat fields (`compute`, `computePerTap`, `upgrades`, `researchNodes`, `singularityShards`, etc.) when the new `planets` key is absent. All other planets are initialised locked from their catalog.

### `GameViewModel` changes

- `var activePlanet: PlanetBoard { state.planets[state.activePlanetIndex] }` (convenience accessor)
- All action methods (`tap`, `buyUpgrade`, `buyToMilestone`, `unlockResearch`, `performPrestige`, `buySingularityUpgrade`) operate on `state.planets[state.activePlanetIndex]`.
- New method: `switchPlanet(to index: Int)` — saves current planet's `lastSaveDate`, updates `activePlanetIndex`.
- New computed: `canUnlockNextPlanet: Bool` — checks 100× final upgrade on active planet.
- Tick timer: earns on the **active planet only**. Offline earnings on return are for the active planet only (keeps it simple; can revisit).
- `mergeNewResearchNodes()` / `mergeNewCatalogEntries()` are called on **every** `PlanetBoard` at launch.

---

## Scaling

Each planet is ×50 harder than the previous. Base costs and base CPS scale by the same factor so time-to-progress stays roughly constant per planet (shards/research bridge the difficulty gap).

| Planet   | Scale Factor | First Upgrade Cost | Last Upgrade Cost |
|----------|--------------|--------------------|-------------------|
| Neptune  | ×1           | 10                 | 400 B             |
| Uranus   | ×50          | 500                | 20 T              |
| Saturn   | ×2,500       | 25 K               | 1 Q               |
| Jupiter  | ×125,000     | 1.25 M             | 50 Q              |
| Mars     | ×6.25 M      | 62.5 M             | 2.5 s             |
| Earth    | ×312.5 M     | 3.125 B            | 125 s             |
| Venus    | ×15.625 B    | 156 B              | 6.25 oc           |
| Mercury  | ×781.25 B    | 7.8 T              | 312 oc            |
| Sun      | ×39 T        | 391 T              | 15.6 N            |

*(K=thousand, M=million, B=billion, T=trillion, Q=quadrillion, s=sextillion, oc=octillion, N=nonillion)*

All 12 upgrades use ×1.15 cost scaling. CPS per upgrade tier scales by ×5 within each planet, same as Neptune.

Singularity thresholds (prestige trigger):

| Planet  | Threshold |
|---------|-----------|
| Neptune | 1 T       |
| Uranus  | 50 T      |
| Saturn  | 2.5 Q     |
| Jupiter | 125 Q     |
| Mars    | 6.25 s    |
| Earth   | 312.5 s   |
| Venus   | 15.625 oc |
| Mercury | 781.25 oc |
| Sun     | 39 N      |

---

## Planet Catalogs

### Cost & CPS Tables (all planets follow the same ×10 CPS per tier, ×costs from scale)

Neptune base CPS per upgrade (per unit): 0.1 / 0.5 / 2 / 10 / 50 / 250 / 1250 / 6250 / 31250 / 156250 / 781250 / 3906250  
All subsequent planets multiply these by their scale factor.

---

### Neptune — "Compute" 🔵

*Existing catalog — retained as-is.*

**Upgrades:** GPU → Server Rack → Data Centre → AI Cluster → Hyperscaler → Quantum Core → Cooling Array → AI Agent → Neural Fabric → Orbital Station → Dyson Swarm → Planetary Grid

**Research:** Efficient Cooling → Parallel Processing → Neural Scaling → Edge Compute → Quantum Tunnelling → Singularity Protocol → Autonomous Replication → Deep Learning Array → Orbital Mesh → Planetary Consciousness

**Unlock next:** 100× Planetary Grid

---

### Uranus — "Ice Flux" 🩵 (teal)

*Theme: cryogenic, tilted axis, methane ice giant*

**Upgrades** (scale ×50):

| # | Name | Base Cost | CPS/unit |
|---|------|-----------|----------|
| 1 | Cryo Chip | 500 | 5 |
| 2 | Frost Node | 3,750 | 25 |
| 3 | Ice Array | 25,000 | 100 |
| 4 | Methane Tap | 200,000 | 500 |
| 5 | Tidal Engine | 2,000,000 | 2,500 |
| 6 | Magnetic Ring | 20,000,000 | 12,500 |
| 7 | Cryo Cluster | 200,000,000 | 62,500 |
| 8 | Axial Harvester | 2,000,000,000 | 312,500 |
| 9 | Ice Shell Core | 20,000,000,000 | 1,562,500 |
| 10 | Orbital Lens | 200,000,000,000 | 7,812,500 |
| 11 | Magnetosphere Web | 2,000,000,000,000 | 39,062,500 |
| 12 | Ice Giant Matrix | 20,000,000,000,000 | 195,312,500 |

**Research** (costs ×50 vs Neptune):

| Node | Cost | Effect |
|------|------|--------|
| Superfluid Grid | 75,000 | ×1.25 Ice Flux/s |
| Phase Lock | 600,000 | ×2,000 per tap |
| Thermal Inversion | 6,000,000 | ×1.5 Ice Flux/s |
| Cryogenic Storage | 60,000,000 | +5h offline cap |
| Axial Resonance | 600,000,000 | ×3 Ice Flux/s |
| Magnetic Collapse | 60,000,000,000 | ×2 IFlux/s + ×2,000 per tap |
| Core Crystallisation | 600,000,000,000 | ×2 Ice Flux/s |
| Diamond Layer | 6,000,000,000,000 | ×3,000 per tap |
| Ether Web | 60,000,000,000,000 | +8h offline cap |
| Ice Singularity | 600,000,000,000,000 | ×5 Ice Flux/s |

**Unlock next:** 100× Ice Giant Matrix

---

### Saturn — "Ring Data" 🪐 (amber/gold)

*Theme: planetary rings, orbital mechanics, titan atmosphere*

**Upgrades** (scale ×2,500):

| # | Name | Base Cost | CPS/unit |
|---|------|-----------|----------|
| 1 | Ring Shard | 25,000 | 250 |
| 2 | Cassini Relay | 187,500 | 1,250 |
| 3 | Titan Station | 1,250,000 | 5,000 |
| 4 | Ring Array | 10,000,000 | 25,000 |
| 5 | Atmospheric Tap | 100,000,000 | 125,000 |
| 6 | Storm Engine | 1,000,000,000 | 625,000 |
| 7 | Orbital Harvester | 10,000,000,000 | 3,125,000 |
| 8 | Hexagon Core | 100,000,000,000 | 15,625,000 |
| 9 | Ring Shepherd | 1,000,000,000,000 | 78,125,000 |
| 10 | Titan Cloud | 10,000,000,000,000 | 390,625,000 |
| 11 | Cassini Web | 100,000,000,000,000 | 1,953,125,000 |
| 12 | Ring Sovereign | 1,000,000,000,000,000 | 9,765,625,000 |

**Research** (costs ×2,500 vs Neptune):

| Node | Cost | Effect |
|------|------|--------|
| Ring Resonance | 3,750,000 | ×1.25 Ring Data/s |
| Shepherd Lock | 30,000,000 | ×2,000 per tap |
| Titan Winds | 300,000,000 | ×1.5 Ring Data/s |
| Icy Vault | 3,000,000,000 | +5h offline cap |
| Great Division | 30,000,000,000 | ×3 Ring Data/s |
| Orbital Cascade | 3,000,000,000,000 | ×2 RData/s + ×2,000 per tap |
| Hexagonal Storm | 30,000,000,000,000 | ×2 Ring Data/s |
| Cassini Finale | 300,000,000,000,000 | ×3,000 per tap |
| Deep Ring Web | 3,000,000,000,000,000 | +8h offline cap |
| Ring Singularity | 30,000,000,000,000,000 | ×5 Ring Data/s |

**Unlock next:** 100× Ring Sovereign

---

### Jupiter — "Storm Data" 🟤 (deep orange/brown)

*Theme: gas giant, Great Red Spot, magnetosphere, moons*

**Upgrades** (scale ×125,000):

| # | Name | Base Cost | CPS/unit |
|---|------|-----------|----------|
| 1 | Storm Cell | 1,250,000 | 12,500 |
| 2 | Ganymede Outpost | 9,375,000 | 62,500 |
| 3 | Europa Relay | 62,500,000 | 250,000 |
| 4 | Io Forge | 500,000,000 | 1,250,000 |
| 5 | Great Red Eye | 5,000,000,000 | 6,250,000 |
| 6 | Magnetotail Siphon | 50,000,000,000 | 31,250,000 |
| 7 | Cloud Layer Array | 500,000,000,000 | 156,250,000 |
| 8 | Ammonia Crystal | 5,000,000,000,000 | 781,250,000 |
| 9 | Jovian Core Tap | 50,000,000,000,000 | 3,906,250,000 |
| 10 | Radiation Belt Web | 500,000,000,000,000 | 19,531,250,000 |
| 11 | Storm Matrix | 5,000,000,000,000,000 | 97,656,250,000 |
| 12 | Great Storm Sovereign | 50,000,000,000,000,000 | 488,281,250,000 |

**Research** — Storm / magnetosphere themed, costs ×125,000 vs Neptune. Same effect structure as prior planets.

| Node | Cost | Effect |
|------|------|--------|
| Jet Stream Sync | 187,500,000 | ×1.25 Storm Data/s |
| Red Spot Lock | 1,500,000,000 | ×2,000 per tap |
| Atmospheric Bands | 15,000,000,000 | ×1.5 Storm Data/s |
| Moon Vault | 150,000,000,000 | +5h offline cap |
| Magnetospheric Burst | 1,500,000,000,000 | ×3 Storm Data/s |
| Io Eruption | 150,000,000,000,000 | ×2 SData/s + ×2,000 per tap |
| Europa Ocean | 1,500,000,000,000,000 | ×2 Storm Data/s |
| Storm Eye Array | 15,000,000,000,000,000 | ×3,000 per tap |
| Radiation Web | 150,000,000,000,000,000 | +8h offline cap |
| Jovian Singularity | 1,500,000,000,000,000,000 | ×5 Storm Data/s |

**Unlock next:** 100× Great Storm Sovereign

---

### Mars — "Dust Data" 🔴 (rust red)

*Theme: colonisation, terraforming, dust storms, Olympus Mons*

**Upgrades** (scale ×6,250,000):

| # | Name | Base Cost | CPS/unit |
|---|------|-----------|----------|
| 1 | Dust Collector | 62,500,000 | 625,000 |
| 2 | Hab Module | 468,750,000 | 3,125,000 |
| 3 | Mining Rig | 3,125,000,000 | 12,500,000 |
| 4 | Areology Lab | 25,000,000,000 | 62,500,000 |
| 5 | Solar Panel Array | 250,000,000,000 | 312,500,000 |
| 6 | Olympus Relay | 2,500,000,000,000 | 1,562,500,000 |
| 7 | Valles Network | 25,000,000,000,000 | 7,812,500,000 |
| 8 | Terraformer | 250,000,000,000,000 | 39,062,500,000 |
| 9 | Polar Cap Extractor | 2,500,000,000,000,000 | 195,312,500,000 |
| 10 | Atmosphere Processor | 25,000,000,000,000,000 | 976,562,500,000 |
| 11 | Canyon Grid | 250,000,000,000,000,000 | 4,882,812,500,000 |
| 12 | Red World Matrix | 2,500,000,000,000,000,000 | 24,414,062,500,000 |

**Research** — colonisation / terraforming themed, costs ×6,250,000 vs Neptune.

| Node | Effect |
|------|--------|
| Dust Storm Filter | ×1.25 Dust Data/s |
| Perchlorate Tap | ×2,000 per tap |
| Thin Air Protocol | ×1.5 Dust Data/s |
| Subsurface Vault | +5h offline cap |
| Olympus Mons Relay | ×3 Dust Data/s |
| Terraforming Pulse | ×2 DData/s + ×2,000 per tap |
| Magnetic Restoration | ×2 Dust Data/s |
| Deep Core Array | ×3,000 per tap |
| Ice Cap Web | +8h offline cap |
| Red Singularity | ×5 Dust Data/s |

**Unlock next:** 100× Red World Matrix

---

### Earth — "Net Data" 🌍 (blue/green)

*Theme: internet, civilisation, digital infrastructure — meta commentary*

**Upgrades** (scale ×312,500,000):

| # | Name | Base Cost | CPS/unit |
|---|------|-----------|----------|
| 1 | Smartphone | 3,125,000,000 | 31,250,000 |
| 2 | Data Farm | 23,437,500,000 | 156,250,000 |
| 3 | Search Engine | 156,250,000,000 | 625,000,000 |
| 4 | Social Network | 1,250,000,000,000 | 3,125,000,000 |
| 5 | Cloud Platform | 12,500,000,000,000 | 15,625,000,000 |
| 6 | AI Foundation | 125,000,000,000,000 | 78,125,000,000 |
| 7 | Smart City | 1,250,000,000,000,000 | 390,625,000,000 |
| 8 | Satellite Mesh | 12,500,000,000,000,000 | 1,953,125,000,000 |
| 9 | Global Brain | 125,000,000,000,000,000 | 9,765,625,000,000 |
| 10 | Ocean Cable | 1,250,000,000,000,000,000 | 48,828,125,000,000 |
| 11 | Atmosphere Net | 12,500,000,000,000,000,000 | 244,140,625,000,000 |
| 12 | World Brain | 125,000,000,000,000,000,000 | 1,220,703,125,000,000 |

**Research** — civilisation / connectivity themed:

| Node | Effect |
|------|--------|
| Fibre Backbone | ×1.25 Net Data/s |
| Viral Protocol | ×2,000 per tap |
| Edge Caching | ×1.5 Net Data/s |
| Dark Web Vault | +5h offline cap |
| Quantum Internet | ×3 Net Data/s |
| Hive Mind | ×2 NData/s + ×2,000 per tap |
| Neural Web | ×2 Net Data/s |
| Deep Packet Array | ×3,000 per tap |
| Orbital Net | +8h offline cap |
| World Singularity | ×5 Net Data/s |

**Unlock next:** 100× World Brain

---

### Venus — "Heat Flux" 🟡 (sulfurous yellow)

*Theme: extreme heat, sulfuric acid clouds, greenhouse effect, hostile*

**Upgrades** (scale ×15,625,000,000):

| # | Name | Base Cost | CPS/unit |
|---|------|-----------|----------|
| 1 | Heat Cell | 156,250,000,000 | 1,562,500,000 |
| 2 | Sulfur Tap | 1,171,875,000,000 | 7,812,500,000 |
| 3 | Cloud Station | 7,812,500,000,000 | 31,250,000,000 |
| 4 | Greenhouse Core | 62,500,000,000,000 | 156,250,000,000 |
| 5 | Volcanic Vent | 625,000,000,000,000 | 781,250,000,000 |
| 6 | Acid Array | 6,250,000,000,000,000 | 3,906,250,000,000 |
| 7 | Pressure Engine | 62,500,000,000,000,000 | 19,531,250,000,000 |
| 8 | Lava Harvester | 625,000,000,000,000,000 | 97,656,250,000,000 |
| 9 | Mantle Tap | 6,250,000,000,000,000,000 | 488,281,250,000,000 |
| 10 | Inferno Grid | 62,500,000,000,000,000,000 | 2,441,406,250,000,000 |
| 11 | Hellscape Web | 625,000,000,000,000,000,000 | 12,207,031,250,000,000 |
| 12 | Venusian Sovereign | 6,250,000,000,000,000,000,000 | 61,035,156,250,000,000 |

**Research** — heat / pressure / chemical themed:

| Node | Effect |
|------|--------|
| Thermal Conductor | ×1.25 Heat Flux/s |
| Pressure Spike | ×2,000 per tap |
| Acid Filtration | ×1.5 Heat Flux/s |
| Cloud Vault | +5h offline cap |
| Runaway Greenhouse | ×3 Heat Flux/s |
| Volcanic Cascade | ×2 HFlux/s + ×2,000 per tap |
| Magma Loop | ×2 Heat Flux/s |
| Inferno Array | ×3,000 per tap |
| Sulfur Web | +8h offline cap |
| Venus Singularity | ×5 Heat Flux/s |

**Unlock next:** 100× Venusian Sovereign

---

### Mercury — "Solar Data" ⚪ (silver/white)

*Theme: extreme temperature swing, craters, minimal atmosphere, closest to Sun*

**Upgrades** (scale ×781,250,000,000):

| # | Name | Base Cost | CPS/unit |
|---|------|-----------|----------|
| 1 | Solar Sliver | 7,812,500,000,000 | 78,125,000,000 |
| 2 | Thermal Plate | 58,593,750,000,000 | 390,625,000,000 |
| 3 | Regolith Node | 390,625,000,000,000 | 1,562,500,000,000 |
| 4 | Perihelion Tap | 3,125,000,000,000,000 | 7,812,500,000,000 |
| 5 | Crater Array | 31,250,000,000,000,000 | 39,062,500,000,000 |
| 6 | Subsolar Station | 312,500,000,000,000,000 | 195,312,500,000,000 |
| 7 | Magnetopause Web | 3,125,000,000,000,000,000 | 976,562,500,000,000 |
| 8 | Exosphere Lens | 31,250,000,000,000,000,000 | 4,882,812,500,000,000 |
| 9 | Solar Wind Siphon | 312,500,000,000,000,000,000 | 24,414,062,500,000,000 |
| 10 | Helium-3 Core | 3,125,000,000,000,000,000,000 | 122,070,312,500,000,000 |
| 11 | Sungrazer Grid | 31,250,000,000,000,000,000,000 | 610,351,562,500,000,000 |
| 12 | Mercury Sovereign | 312,500,000,000,000,000,000,000 | 3,051,757,812,500,000,000 |

**Research** — solar proximity / extreme cycles themed:

| Node | Effect |
|------|--------|
| Day-Night Cycle | ×1.25 Solar Data/s |
| Perihelion Burst | ×2,000 per tap |
| Crater Insulation | ×1.5 Solar Data/s |
| Ice Shadow Vault | +5h offline cap |
| Resonance Lock | ×3 Solar Data/s |
| Solar Storm | ×2 SolData/s + ×2,000 per tap |
| Magnetopause Field | ×2 Solar Data/s |
| Helium-3 Array | ×3,000 per tap |
| Exosphere Web | +8h offline cap |
| Mercury Singularity | ×5 Solar Data/s |

**Unlock next:** 100× Mercury Sovereign

---

### Sun — "Stellar Flux" ☀️ (bright gold/orange)

*Theme: fusion, stellar evolution, the source of all energy — final board*

**Upgrades** (scale ×39,062,500,000,000):

| # | Name | Base Cost | CPS/unit |
|---|------|-----------|----------|
| 1 | Solar Flare | 390,625,000,000,000 | 3,906,250,000,000 |
| 2 | Prominence Array | 2,929,687,500,000,000 | 19,531,250,000,000 |
| 3 | Photosphere Engine | 19,531,250,000,000,000 | 78,125,000,000,000 |
| 4 | Chromosphere Web | 156,250,000,000,000,000 | 390,625,000,000,000 |
| 5 | Corona Harvester | 1,562,500,000,000,000,000 | 1,953,125,000,000,000 |
| 6 | Solar Wind Matrix | 15,625,000,000,000,000,000 | 9,765,625,000,000,000 |
| 7 | Magnetosphere Core | 156,250,000,000,000,000,000 | 48,828,125,000,000,000 |
| 8 | Convection Tap | 1,562,500,000,000,000,000,000 | 244,140,625,000,000,000 |
| 9 | Radiation Engine | 15,625,000,000,000,000,000,000 | 1,220,703,125,000,000,000 |
| 10 | Core Plasma Array | 156,250,000,000,000,000,000,000 | 6,103,515,625,000,000,000 |
| 11 | Fusion Sovereign | 1,562,500,000,000,000,000,000,000 | 30,517,578,125,000,000,000 |
| 12 | Star Brain | 15,625,000,000,000,000,000,000,000 | 152,587,890,625,000,000,000 |

**Research** — fusion / stellar evolution themed:

| Node | Effect |
|------|--------|
| Plasma Conductor | ×1.25 Stellar Flux/s |
| Fusion Spark | ×2,000 per tap |
| Helioseismology | ×1.5 Stellar Flux/s |
| Solar Minimum Vault | +5h offline cap |
| CNO Cycle | ×3 Stellar Flux/s |
| Solar Maximum | ×2 SFlux/s + ×2,000 per tap |
| Stellar Core Lock | ×2 Stellar Flux/s |
| Neutrino Array | ×3,000 per tap |
| Coronal Web | +8h offline cap |
| Star Singularity | ×5 Stellar Flux/s |

**No next planet — this is the final board.**

---

## Auto-Tapper

Each planet unlocks auto-tap when the player owns ≥25 of its **first** upgrade (same rule as Neptune's GPU threshold).

---

## UI Changes

### Planet Switcher (top of screen)

A tappable pill/button displayed **above** the `StatsHeaderView` (or inside it as a top row). Shows the current planet emoji + name. Tapping opens `PlanetSelectView` as a full-screen sheet.

```
[ 🔵 NEPTUNE ▾ ]
```

### `PlanetSelectView` (new sheet)

Full-screen sheet with a scrollable list/grid of all 9 planets.

Each planet card shows:
- Emoji + name
- Resource name
- Lock icon if not yet unlocked
- If locked: progress bar showing "X / 100 [final upgrade name]" toward unlock
- If unlocked: brief CPS summary or "ACTIVE" badge
- Tapping an unlocked planet switches to it

Only Neptune is available on a fresh save.

### `StatsHeaderView` updates

- Replace hardcoded "COMPUTE" label with `activePlanet`'s `resourceName`
- Show planet emoji alongside the label

### `SingularityView` updates

- Replace hardcoded "SINGULARITY" text with planet-flavoured copy (e.g. "ICE COLLAPSE" on Uranus)
- The kept/reset table row for research stays the same

### `ContentView` updates

- Add planet switcher button above `StatsHeaderView`
- Pass `vm` through as-is (views already read from `vm.state`; after refactor they read from `vm.activePlanet`)

---

## Save Migration

Old saves (pre-planets) have top-level `compute`, `computePerTap`, `upgrades`, `researchNodes`, `singularityShards`, `singularityPoints`, `singularityUpgradeLevels`, `lastSaveDate` keys.

Migration in `GameState.init(from:)`:

```
if let planets = try? c.decode([PlanetBoard].self, forKey: .planets) {
    self.planets = planets
    self.activePlanetIndex = (try? c.decode(Int.self, forKey: .activePlanetIndex)) ?? 0
} else {
    // Old save: reconstruct Neptune PlanetBoard from flat keys
    let neptune = PlanetBoard(migratingFrom: c)   // reads old keys
    var allPlanets = PlanetDefinition.all.map { PlanetBoard(fresh: $0) }
    allPlanets[0] = neptune
    self.planets = allPlanets
    self.activePlanetIndex = 0
}
```

---

## Implementation Sections

Split into these independent sections for implementation:

### Section 1 — Core Models
- Create `PlanetBoard.swift`: Codable state struct with all computed properties moved from `GameState`
- Create `PlanetDefinition.swift`: static data struct + Neptune catalog (copy from existing)
- Keep `Upgrade.swift` and `ResearchNode.swift` unchanged

### Section 2 — Planet Content
- Add remaining 8 planet catalogs to `PlanetDefinition.all` (Uranus → Sun) using the tables above
- Each planet's `upgradeCatalog` and `researchCatalog` entries

### Section 3 — GameState Refactor
- Restructure `GameState` to hold `[PlanetBoard]` + `activePlanetIndex` + `achievements`
- Add backwards-compatible decoder (migrate old Neptune saves)
- Update `mergeNew*` calls to iterate all planets

### Section 4 — GameViewModel Updates
- Redirect all action methods to `state.planets[state.activePlanetIndex]`
- Add `switchPlanet(to:)` and `canUnlockNextPlanet` computed property
- Update tick timer to use active planet
- Update `offlineEarnings` to use active planet

### Section 5 — PlanetSelectView
- New `PlanetSelectView.swift` with planet grid/list
- Planet card component with lock/progress state
- Uses `PlanetDefinition.all` for display, `state.planets` for runtime state

### Section 6 — ContentView & Header Updates
- Add planet switcher button at top
- Sheet presentation of `PlanetSelectView`
- Update `StatsHeaderView` to read resource name from active planet definition

### Section 7 — Child View Updates
- `UpgradesListView`, `ResearchView`, `SingularityUpgradesView`: replace `vm.state.X` references with `vm.activePlanet.X`
- `SingularityView`: pass planet name for flavour text
- `TapButtonView`: resource label already uses `effectiveComputePerTap` — no change needed

### Section 8 — Achievements & Polish
- Add new achievements: first planet unlock, all planets unlocked, planet-specific milestones
- Planet-coloured accent in UI (per `PlanetDefinition.accentColorHex`)
- Theme colour swaps when switching planets

---

## Open Questions / Decisions

1. **Offline earnings**: Active planet only, or all planets tick while offline? (Recommendation: active planet only for simplicity.)
2. **Cross-planet shards**: Shards are per-planet (recommended) or global?
3. **Number formatting**: Current `compactFormatted` goes to Q (quadrillion). Needs extending to sextillion / octillion / nonillion for later planets.
4. **Planet colour theming**: Swap the neon cyan accent per planet, or keep a consistent UI and just change labels?
