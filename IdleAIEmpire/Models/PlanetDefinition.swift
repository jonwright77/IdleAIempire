import SwiftUI

struct PlanetDefinition {
    let id: String
    let name: String
    let emoji: String
    let accentColor: Color
    let resourceName: String
    let singularityThreshold: Double
    let singularityName: String       // flavour name for the prestige event
    let upgradeCatalog: [Upgrade]
    let researchCatalog: [ResearchNode]

    static let all: [PlanetDefinition] = [
        neptune, uranus, saturn, jupiter, mars, earth, venus, mercury, sun
    ]
}

// MARK: - Neptune

extension PlanetDefinition {
    static let neptune = PlanetDefinition(
        id: "neptune",
        name: "Neptune",
        emoji: "🔵",
        accentColor: .planetNeptune,
        resourceName: "Compute",
        singularityThreshold: 1e12,
        singularityName: "Singularity",
        upgradeCatalog: Upgrade.catalog,
        researchCatalog: ResearchNode.catalog
    )
}

// MARK: - Uranus

extension PlanetDefinition {
    static let uranus = PlanetDefinition(
        id: "uranus",
        name: "Uranus",
        emoji: "🩵",
        accentColor: .planetUranus,
        resourceName: "Ice Flux",
        singularityThreshold: 5e13,
        singularityName: "Ice Collapse",
        upgradeCatalog: [
            Upgrade(id: "cryo_chip",         name: "Cryo Chip",         flavor: "Silicon that thrives at near-absolute zero.",                       baseCost: 500,           costMultiplier: 1.15, baseComputePerSecond: 5,           owned: 0),
            Upgrade(id: "frost_node",        name: "Frost Node",        flavor: "A processing cluster wrapped in frozen methane.",                   baseCost: 3_750,         costMultiplier: 1.15, baseComputePerSecond: 25,          owned: 0),
            Upgrade(id: "ice_array",         name: "Ice Array",         flavor: "Crystalline lattices channelling cryo-data across the ice shell.",  baseCost: 25_000,        costMultiplier: 1.15, baseComputePerSecond: 100,         owned: 0),
            Upgrade(id: "methane_tap",       name: "Methane Tap",       flavor: "Siphoning heat differentials from liquid methane oceans.",          baseCost: 200_000,       costMultiplier: 1.15, baseComputePerSecond: 500,         owned: 0),
            Upgrade(id: "tidal_engine",      name: "Tidal Engine",      flavor: "Gravitational flex from distant moons drives the flux.",            baseCost: 2_000_000,     costMultiplier: 1.15, baseComputePerSecond: 2_500,       owned: 0),
            Upgrade(id: "magnetic_ring",     name: "Magnetic Ring",     flavor: "Looping field lines around the tilted axis amplify output.",        baseCost: 20_000_000,    costMultiplier: 1.15, baseComputePerSecond: 12_500,      owned: 0),
            Upgrade(id: "cryo_cluster",      name: "Cryo Cluster",      flavor: "An array of frost processors sharing thermal load.",                baseCost: 200_000_000,   costMultiplier: 1.15, baseComputePerSecond: 62_500,      owned: 0),
            Upgrade(id: "axial_harvester",   name: "Axial Harvester",   flavor: "Unique 98-degree tilt harvested as a perpetual energy gradient.",   baseCost: 2_000_000_000, costMultiplier: 1.15, baseComputePerSecond: 312_500,     owned: 0),
            Upgrade(id: "ice_shell_core",    name: "Ice Shell Core",    flavor: "Deep-mantle crystalline compute buried beneath kilometres of ice.", baseCost: 2e10,          costMultiplier: 1.15, baseComputePerSecond: 1_562_500,   owned: 0),
            Upgrade(id: "orbital_lens",      name: "Orbital Lens",      flavor: "Ring debris focused into precision data relay nodes.",              baseCost: 2e11,          costMultiplier: 1.15, baseComputePerSecond: 7_812_500,   owned: 0),
            Upgrade(id: "magnetosphere_web", name: "Magnetosphere Web", flavor: "The planet's strange magnetic field woven into a computation net.", baseCost: 2e12,          costMultiplier: 1.15, baseComputePerSecond: 39_062_500,  owned: 0),
            Upgrade(id: "ice_giant_matrix",  name: "Ice Giant Matrix",  flavor: "The whole ice giant unified as a single cryo-computation engine.",  baseCost: 2e13,          costMultiplier: 1.15, baseComputePerSecond: 195_312_500, owned: 0),
        ],
        researchCatalog: [
            ResearchNode(id: "superfluid_grid",      name: "Superfluid Grid",      flavor: "Zero-resistance pathways accelerate every Ice Flux stream.",      effectSummary: "×1.25 Ice Flux/s",            cost: 75_000,        cpsMultiplier: 1.25, tapMultiplier: 1.0,    offlineHoursBonus: 0, unlocked: false),
            ResearchNode(id: "phase_lock",           name: "Phase Lock",           flavor: "Synchronised phase transitions amplify each tap cascade.",         effectSummary: "×2,000 per tap",              cost: 600_000,       cpsMultiplier: 1.0,  tapMultiplier: 2000,   offlineHoursBonus: 0, unlocked: false),
            ResearchNode(id: "thermal_inversion",    name: "Thermal Inversion",    flavor: "Exploiting the atmospheric cold-hot boundary doubles throughput.", effectSummary: "×1.5 Ice Flux/s",             cost: 6_000_000,     cpsMultiplier: 1.5,  tapMultiplier: 1.0,    offlineHoursBonus: 0, unlocked: false),
            ResearchNode(id: "cryogenic_storage",    name: "Cryogenic Storage",    flavor: "Supercooled vaults preserve Ice Flux while you're away.",          effectSummary: "+5h offline cap",             cost: 60_000_000,    cpsMultiplier: 1.0,  tapMultiplier: 1.0,    offlineHoursBonus: 5, unlocked: false),
            ResearchNode(id: "axial_resonance",      name: "Axial Resonance",      flavor: "Resonant wobble of the tilted axis triples passive output.",       effectSummary: "×3 Ice Flux/s",               cost: 600_000_000,   cpsMultiplier: 3.0,  tapMultiplier: 1.0,    offlineHoursBonus: 0, unlocked: false),
            ResearchNode(id: "magnetic_collapse",    name: "Magnetic Collapse",    flavor: "Controlled field collapse boosts all production.",                 effectSummary: "×2 IFlux/s · ×2,000 per tap", cost: 6e10,          cpsMultiplier: 2.0,  tapMultiplier: 2000,   offlineHoursBonus: 0, unlocked: false),
            ResearchNode(id: "core_crystallisation", name: "Core Crystallisation", flavor: "Inner mantle crystallises into a perfect compute lattice.",        effectSummary: "×2 Ice Flux/s",               cost: 6e11,          cpsMultiplier: 2.0,  tapMultiplier: 1.0,    offlineHoursBonus: 0, unlocked: false),
            ResearchNode(id: "diamond_layer",        name: "Diamond Layer",        flavor: "Pressure-formed diamond conducts every tap with perfect fidelity.", effectSummary: "×3,000 per tap",              cost: 6e12,          cpsMultiplier: 1.0,  tapMultiplier: 3000,   offlineHoursBonus: 0, unlocked: false),
            ResearchNode(id: "ether_web",            name: "Ether Web",            flavor: "A diffuse orbital net keeps earning long after you log off.",      effectSummary: "+8h offline cap",             cost: 6e13,          cpsMultiplier: 1.0,  tapMultiplier: 1.0,    offlineHoursBonus: 8, unlocked: false),
            ResearchNode(id: "ice_singularity",      name: "Ice Singularity",      flavor: "All Ice Flux converges into a single unstoppable cascade.",        effectSummary: "×5 Ice Flux/s",               cost: 6e14,          cpsMultiplier: 5.0,  tapMultiplier: 1.0,    offlineHoursBonus: 0, unlocked: false),
        ]
    )
}

// MARK: - Saturn

extension PlanetDefinition {
    static let saturn = PlanetDefinition(
        id: "saturn",
        name: "Saturn",
        emoji: "🪐",
        accentColor: .planetSaturn,
        resourceName: "Ring Data",
        singularityThreshold: 2.5e15,
        singularityName: "Ring Collapse",
        upgradeCatalog: [
            Upgrade(id: "ring_shard",        name: "Ring Shard",        flavor: "Fragments of ice and rock refined into data carriers.",            baseCost: 25_000,        costMultiplier: 1.15, baseComputePerSecond: 250,         owned: 0),
            Upgrade(id: "cassini_relay",     name: "Cassini Relay",     flavor: "Orbital relays echoing the legendary Cassini mission.",           baseCost: 187_500,       costMultiplier: 1.15, baseComputePerSecond: 1_250,       owned: 0),
            Upgrade(id: "titan_station",     name: "Titan Station",     flavor: "A methane-sea data hub on Saturn's largest moon.",                baseCost: 1_250_000,     costMultiplier: 1.15, baseComputePerSecond: 5_000,       owned: 0),
            Upgrade(id: "ring_array",        name: "Ring Array",        flavor: "Thousands of ring particles aligned as an antenna farm.",          baseCost: 1e7,           costMultiplier: 1.15, baseComputePerSecond: 25_000,      owned: 0),
            Upgrade(id: "atmospheric_tap",   name: "Atmospheric Tap",   flavor: "Hydrogen and helium storms harvested for massive throughput.",     baseCost: 1e8,           costMultiplier: 1.15, baseComputePerSecond: 125_000,     owned: 0),
            Upgrade(id: "storm_engine",      name: "Storm Engine",      flavor: "Perpetual superstorms converted into stable Ring Data output.",    baseCost: 1e9,           costMultiplier: 1.15, baseComputePerSecond: 625_000,     owned: 0),
            Upgrade(id: "orbital_harvester", name: "Orbital Harvester", flavor: "Shepherd moons herded into synchronised data relays.",             baseCost: 1e10,          costMultiplier: 1.15, baseComputePerSecond: 3_125_000,   owned: 0),
            Upgrade(id: "hexagon_core",      name: "Hexagon Core",      flavor: "The north polar hexagon — a perfect natural processor.",           baseCost: 1e11,          costMultiplier: 1.15, baseComputePerSecond: 15_625_000,  owned: 0),
            Upgrade(id: "ring_shepherd",     name: "Ring Shepherd",     flavor: "Gravitational shepherding turns the ring system into a CPU.",      baseCost: 1e12,          costMultiplier: 1.15, baseComputePerSecond: 78_125_000,  owned: 0),
            Upgrade(id: "titan_cloud",       name: "Titan Cloud",       flavor: "Hydrocarbon clouds on Titan tapped as a distributed computer.",    baseCost: 1e13,          costMultiplier: 1.15, baseComputePerSecond: 390_625_000, owned: 0),
            Upgrade(id: "cassini_web",       name: "Cassini Web",       flavor: "A web of resonant orbits spanning the entire ring system.",        baseCost: 1e14,          costMultiplier: 1.15, baseComputePerSecond: 1_953_125_000, owned: 0),
            Upgrade(id: "ring_sovereign",    name: "Ring Sovereign",    flavor: "Saturn herself subjugated — rings, moons, storms unified.",        baseCost: 1e15,          costMultiplier: 1.15, baseComputePerSecond: 9_765_625_000, owned: 0),
        ],
        researchCatalog: [
            ResearchNode(id: "ring_resonance",   name: "Ring Resonance",   flavor: "Orbital resonance amplifies every Ring Data stream.",            effectSummary: "×1.25 Ring Data/s",             cost: 3_750_000,  cpsMultiplier: 1.25, tapMultiplier: 1.0,  offlineHoursBonus: 0, unlocked: false),
            ResearchNode(id: "shepherd_lock",    name: "Shepherd Lock",    flavor: "Shepherd-moon gravity lock multiplies each manual harvest.",     effectSummary: "×2,000 per tap",                cost: 3e7,        cpsMultiplier: 1.0,  tapMultiplier: 2000, offlineHoursBonus: 0, unlocked: false),
            ResearchNode(id: "titan_winds",      name: "Titan Winds",      flavor: "Nitrogen winds on Titan re-routed through ring processors.",     effectSummary: "×1.5 Ring Data/s",              cost: 3e8,        cpsMultiplier: 1.5,  tapMultiplier: 1.0,  offlineHoursBonus: 0, unlocked: false),
            ResearchNode(id: "icy_vault",        name: "Icy Vault",        flavor: "Ring ice stores Ring Data safely for deep offline periods.",     effectSummary: "+5h offline cap",               cost: 3e9,        cpsMultiplier: 1.0,  tapMultiplier: 1.0,  offlineHoursBonus: 5, unlocked: false),
            ResearchNode(id: "great_division",   name: "Great Division",   flavor: "The Cassini Division weaponised as a data-sorting barrier.",     effectSummary: "×3 Ring Data/s",                cost: 3e10,       cpsMultiplier: 3.0,  tapMultiplier: 1.0,  offlineHoursBonus: 0, unlocked: false),
            ResearchNode(id: "orbital_cascade",  name: "Orbital Cascade",  flavor: "Resonant cascade across all rings triples active production.",   effectSummary: "×2 RData/s · ×2,000 per tap",  cost: 3e12,       cpsMultiplier: 2.0,  tapMultiplier: 2000, offlineHoursBonus: 0, unlocked: false),
            ResearchNode(id: "hexagonal_storm",  name: "Hexagonal Storm",  flavor: "The polar hexagon storm self-organises into a ring computer.",   effectSummary: "×2 Ring Data/s",                cost: 3e13,       cpsMultiplier: 2.0,  tapMultiplier: 1.0,  offlineHoursBonus: 0, unlocked: false),
            ResearchNode(id: "cassini_finale",   name: "Cassini Finale",   flavor: "Terminal ring dive generates an immense burst on each tap.",     effectSummary: "×3,000 per tap",                cost: 3e14,       cpsMultiplier: 1.0,  tapMultiplier: 3000, offlineHoursBonus: 0, unlocked: false),
            ResearchNode(id: "deep_ring_web",    name: "Deep Ring Web",    flavor: "Sub-ring microstructures extend offline harvesting.",            effectSummary: "+8h offline cap",               cost: 3e15,       cpsMultiplier: 1.0,  tapMultiplier: 1.0,  offlineHoursBonus: 8, unlocked: false),
            ResearchNode(id: "ring_singularity", name: "Ring Singularity", flavor: "The rings collapse inward and the data density becomes infinite.",effectSummary: "×5 Ring Data/s",               cost: 3e16,       cpsMultiplier: 5.0,  tapMultiplier: 1.0,  offlineHoursBonus: 0, unlocked: false),
        ]
    )
}

// MARK: - Jupiter

extension PlanetDefinition {
    static let jupiter = PlanetDefinition(
        id: "jupiter",
        name: "Jupiter",
        emoji: "🟠",
        accentColor: .planetJupiter,
        resourceName: "Storm Data",
        singularityThreshold: 1.25e17,
        singularityName: "Storm Collapse",
        upgradeCatalog: [
            Upgrade(id: "storm_cell",           name: "Storm Cell",           flavor: "A single atmospheric vortex wired as a processor node.",          baseCost: 1_250_000,   costMultiplier: 1.15, baseComputePerSecond: 12_500,       owned: 0),
            Upgrade(id: "ganymede_outpost",     name: "Ganymede Outpost",     flavor: "Data hub on the Solar System's largest moon.",                    baseCost: 9_375_000,   costMultiplier: 1.15, baseComputePerSecond: 62_500,       owned: 0),
            Upgrade(id: "europa_relay",         name: "Europa Relay",         flavor: "Subsurface ocean of Europa used as a thermal signal medium.",     baseCost: 6.25e7,      costMultiplier: 1.15, baseComputePerSecond: 250_000,      owned: 0),
            Upgrade(id: "io_forge",             name: "Io Forge",             flavor: "Volcanic Io: superheated plasma funnelled into compute cores.",   baseCost: 5e8,         costMultiplier: 1.15, baseComputePerSecond: 1_250_000,    owned: 0),
            Upgrade(id: "great_red_eye",        name: "Great Red Eye",        flavor: "The Great Red Spot — a centuries-old storm made computational.", baseCost: 5e9,         costMultiplier: 1.15, baseComputePerSecond: 6_250_000,    owned: 0),
            Upgrade(id: "magnetotail_siphon",   name: "Magnetotail Siphon",   flavor: "Jupiter's vast magnetotail harvested as a Storm Data pipeline.",  baseCost: 5e10,        costMultiplier: 1.15, baseComputePerSecond: 31_250_000,   owned: 0),
            Upgrade(id: "cloud_layer_array",    name: "Cloud Layer Array",    flavor: "Three-banded cloud decks acting as parallel processor layers.",   baseCost: 5e11,        costMultiplier: 1.15, baseComputePerSecond: 156_250_000,  owned: 0),
            Upgrade(id: "ammonia_crystal",      name: "Ammonia Crystal",      flavor: "Upper atmosphere crystal nodes conducting storm signals.",        baseCost: 5e12,        costMultiplier: 1.15, baseComputePerSecond: 781_250_000,  owned: 0),
            Upgrade(id: "jovian_core_tap",      name: "Jovian Core Tap",      flavor: "A metallic hydrogen core — the most exotic conductor known.",     baseCost: 5e13,        costMultiplier: 1.15, baseComputePerSecond: 3_906_250_000, owned: 0),
            Upgrade(id: "radiation_belt_web",   name: "Radiation Belt Web",   flavor: "Van Allen-scale radiation belts converted to a data substrate.",  baseCost: 5e14,        costMultiplier: 1.15, baseComputePerSecond: 1.953125e10,  owned: 0),
            Upgrade(id: "storm_matrix",         name: "Storm Matrix",         flavor: "All storm systems cross-linked into a planetary-scale computer.", baseCost: 5e15,        costMultiplier: 1.15, baseComputePerSecond: 9.765625e10,  owned: 0),
            Upgrade(id: "great_storm_sovereign",name: "Great Storm Sovereign",flavor: "Jupiter's entire storm system — one eternal, unstoppable engine.", baseCost: 5e16,        costMultiplier: 1.15, baseComputePerSecond: 4.8828125e11, owned: 0),
        ],
        researchCatalog: [
            ResearchNode(id: "jet_stream_sync",    name: "Jet Stream Sync",    flavor: "Synchronised jet streams multiply passive Storm Data output.",    effectSummary: "×1.25 Storm Data/s",            cost: 1.875e8, cpsMultiplier: 1.25, tapMultiplier: 1.0,  offlineHoursBonus: 0, unlocked: false),
            ResearchNode(id: "red_spot_lock",      name: "Red Spot Lock",      flavor: "Locking onto the Red Spot's rotation unleashes tap cascades.",   effectSummary: "×2,000 per tap",                cost: 1.5e9,  cpsMultiplier: 1.0,  tapMultiplier: 2000, offlineHoursBonus: 0, unlocked: false),
            ResearchNode(id: "atmospheric_bands",  name: "Atmospheric Bands",  flavor: "Belt-zone circulation re-engineered as a throughput multiplier.", effectSummary: "×1.5 Storm Data/s",             cost: 1.5e10, cpsMultiplier: 1.5,  tapMultiplier: 1.0,  offlineHoursBonus: 0, unlocked: false),
            ResearchNode(id: "moon_vault",         name: "Moon Vault",         flavor: "Galilean moons store Storm Data for extended offline windows.",   effectSummary: "+5h offline cap",               cost: 1.5e11, cpsMultiplier: 1.0,  tapMultiplier: 1.0,  offlineHoursBonus: 5, unlocked: false),
            ResearchNode(id: "magnetospheric_burst",name: "Magnetospheric Burst",flavor:"Jupiter's magnetosphere energises all output threefold.",        effectSummary: "×3 Storm Data/s",               cost: 1.5e12, cpsMultiplier: 3.0,  tapMultiplier: 1.0,  offlineHoursBonus: 0, unlocked: false),
            ResearchNode(id: "io_eruption",        name: "Io Eruption",        flavor: "Synchronised Io eruptions blast Storm Data in every tap.",       effectSummary: "×2 SData/s · ×2,000 per tap",  cost: 1.5e14, cpsMultiplier: 2.0,  tapMultiplier: 2000, offlineHoursBonus: 0, unlocked: false),
            ResearchNode(id: "europa_ocean",       name: "Europa Ocean",       flavor: "Subsurface currents of Europa drive passive doubling.",           effectSummary: "×2 Storm Data/s",               cost: 1.5e15, cpsMultiplier: 2.0,  tapMultiplier: 1.0,  offlineHoursBonus: 0, unlocked: false),
            ResearchNode(id: "storm_eye_array",    name: "Storm Eye Array",    flavor: "The eye of every storm becomes a precise tap amplifier.",        effectSummary: "×3,000 per tap",                cost: 1.5e16, cpsMultiplier: 1.0,  tapMultiplier: 3000, offlineHoursBonus: 0, unlocked: false),
            ResearchNode(id: "radiation_web",      name: "Radiation Web",      flavor: "A radiation-belt mesh harvests flux far into offline periods.",   effectSummary: "+8h offline cap",               cost: 1.5e17, cpsMultiplier: 1.0,  tapMultiplier: 1.0,  offlineHoursBonus: 8, unlocked: false),
            ResearchNode(id: "jovian_singularity", name: "Jovian Singularity", flavor: "Jupiter's storms collapse to a point of infinite density.",      effectSummary: "×5 Storm Data/s",               cost: 1.5e18, cpsMultiplier: 5.0,  tapMultiplier: 1.0,  offlineHoursBonus: 0, unlocked: false),
        ]
    )
}

// MARK: - Mars

extension PlanetDefinition {
    static let mars = PlanetDefinition(
        id: "mars",
        name: "Mars",
        emoji: "🔴",
        accentColor: .planetMars,
        resourceName: "Dust Data",
        singularityThreshold: 6.25e18,
        singularityName: "Dust Collapse",
        upgradeCatalog: [
            Upgrade(id: "dust_collector",       name: "Dust Collector",       flavor: "Electrostatic panels sifting compute from Martian dust storms.",  baseCost: 6.25e7,    costMultiplier: 1.15, baseComputePerSecond: 625_000,       owned: 0),
            Upgrade(id: "hab_module",           name: "Hab Module",           flavor: "Pressurised hab domes doubling as distributed data centres.",     baseCost: 4.6875e8,  costMultiplier: 1.15, baseComputePerSecond: 3_125_000,     owned: 0),
            Upgrade(id: "mining_rig",           name: "Mining Rig",           flavor: "Sub-surface drilling rigs tapping geothermal compute veins.",     baseCost: 3.125e9,   costMultiplier: 1.15, baseComputePerSecond: 12_500_000,    owned: 0),
            Upgrade(id: "areology_lab",         name: "Areology Lab",         flavor: "Rock-analysis labs repurposed as planet-scale sensors.",          baseCost: 2.5e10,    costMultiplier: 1.15, baseComputePerSecond: 62_500_000,    owned: 0),
            Upgrade(id: "solar_panel_array",    name: "Solar Panel Array",    flavor: "Vast desert plains blanketed in photovoltaic compute arrays.",    baseCost: 2.5e11,    costMultiplier: 1.15, baseComputePerSecond: 312_500_000,   owned: 0),
            Upgrade(id: "olympus_relay",        name: "Olympus Relay",        flavor: "Olympus Mons summit: highest compute relay in the Solar System.", baseCost: 2.5e12,    costMultiplier: 1.15, baseComputePerSecond: 1_562_500_000, owned: 0),
            Upgrade(id: "valles_network",       name: "Valles Network",       flavor: "Valles Marineris — a canyon 4,000 km of fibre running its length.",baseCost: 2.5e13,   costMultiplier: 1.15, baseComputePerSecond: 7.8125e9,      owned: 0),
            Upgrade(id: "terraformer",          name: "Terraformer",          flavor: "Atmospheric processors that double as planetary-scale computers.", baseCost: 2.5e14,    costMultiplier: 1.15, baseComputePerSecond: 3.90625e10,    owned: 0),
            Upgrade(id: "polar_cap_extractor",  name: "Polar Cap Extractor",  flavor: "CO2 ice caps mined for a dense cryo-compute substrate.",          baseCost: 2.5e15,    costMultiplier: 1.15, baseComputePerSecond: 1.953125e11,   owned: 0),
            Upgrade(id: "atmosphere_processor", name: "Atmosphere Processor", flavor: "Thin atmosphere thickened with compute-saturated particulates.",   baseCost: 2.5e16,    costMultiplier: 1.15, baseComputePerSecond: 9.765625e11,   owned: 0),
            Upgrade(id: "canyon_grid",          name: "Canyon Grid",          flavor: "Every canyon and crater wired into a planet-spanning grid.",       baseCost: 2.5e17,    costMultiplier: 1.15, baseComputePerSecond: 4.8828125e12,  owned: 0),
            Upgrade(id: "red_world_matrix",     name: "Red World Matrix",     flavor: "Mars itself becomes one colossal Dust Data processor.",           baseCost: 2.5e18,    costMultiplier: 1.15, baseComputePerSecond: 2.44140625e13, owned: 0),
        ],
        researchCatalog: [
            ResearchNode(id: "dust_storm_filter",   name: "Dust Storm Filter",   flavor: "Perchlorates filtered out; signal clarity multiplies output.",   effectSummary: "×1.25 Dust Data/s",             cost: 9.375e7, cpsMultiplier: 1.25, tapMultiplier: 1.0,  offlineHoursBonus: 0, unlocked: false),
            ResearchNode(id: "perchlorate_tap",     name: "Perchlorate Tap",     flavor: "Toxic dust chemistry weaponised into a tap-burst amplifier.",    effectSummary: "×2,000 per tap",                 cost: 7.5e8,  cpsMultiplier: 1.0,  tapMultiplier: 2000, offlineHoursBonus: 0, unlocked: false),
            ResearchNode(id: "thin_air_protocol",   name: "Thin Air Protocol",   flavor: "The thin atmosphere used as a low-latency signal medium.",       effectSummary: "×1.5 Dust Data/s",              cost: 7.5e9,  cpsMultiplier: 1.5,  tapMultiplier: 1.0,  offlineHoursBonus: 0, unlocked: false),
            ResearchNode(id: "subsurface_vault",    name: "Subsurface Vault",    flavor: "Underground caverns preserve Dust Data through long nights.",    effectSummary: "+5h offline cap",                cost: 7.5e10, cpsMultiplier: 1.0,  tapMultiplier: 1.0,  offlineHoursBonus: 5, unlocked: false),
            ResearchNode(id: "olympus_mons_relay",  name: "Olympus Mons Relay",  flavor: "Tallest volcano in the system becomes a tripling broadcaster.",  effectSummary: "×3 Dust Data/s",                 cost: 7.5e11, cpsMultiplier: 3.0,  tapMultiplier: 1.0,  offlineHoursBonus: 0, unlocked: false),
            ResearchNode(id: "terraforming_pulse",  name: "Terraforming Pulse",  flavor: "Global terraforming event cascades through all production.",     effectSummary: "×2 DData/s · ×2,000 per tap",   cost: 7.5e13, cpsMultiplier: 2.0,  tapMultiplier: 2000, offlineHoursBonus: 0, unlocked: false),
            ResearchNode(id: "magnetic_restoration",name: "Magnetic Restoration",flavor: "Restoring Mars's lost magnetosphere doubles passive flux.",      effectSummary: "×2 Dust Data/s",                 cost: 7.5e14, cpsMultiplier: 2.0,  tapMultiplier: 1.0,  offlineHoursBonus: 0, unlocked: false),
            ResearchNode(id: "deep_core_array",     name: "Deep Core Array",     flavor: "Iron core tapped for a 3,000× per-tap burst.",                  effectSummary: "×3,000 per tap",                 cost: 7.5e15, cpsMultiplier: 1.0,  tapMultiplier: 3000, offlineHoursBonus: 0, unlocked: false),
            ResearchNode(id: "ice_cap_web",         name: "Ice Cap Web",         flavor: "Polar ice cap sensor web extends offline data capture.",         effectSummary: "+8h offline cap",                cost: 7.5e16, cpsMultiplier: 1.0,  tapMultiplier: 1.0,  offlineHoursBonus: 8, unlocked: false),
            ResearchNode(id: "red_singularity",     name: "Red Singularity",     flavor: "The red dust converges — a planet-wide compute singularity.",    effectSummary: "×5 Dust Data/s",                 cost: 7.5e17, cpsMultiplier: 5.0,  tapMultiplier: 1.0,  offlineHoursBonus: 0, unlocked: false),
        ]
    )
}

// MARK: - Earth

extension PlanetDefinition {
    static let earth = PlanetDefinition(
        id: "earth",
        name: "Earth",
        emoji: "🌍",
        accentColor: .planetEarth,
        resourceName: "Net Data",
        singularityThreshold: 3.125e20,
        singularityName: "Network Collapse",
        upgradeCatalog: [
            Upgrade(id: "smartphone",       name: "Smartphone",       flavor: "Billions of pocket computers harnessed as a distributed network.",  baseCost: 3.125e9,   costMultiplier: 1.15, baseComputePerSecond: 3.125e7,    owned: 0),
            Upgrade(id: "data_farm",        name: "Data Farm",        flavor: "Industrial data farms processing the world's information flows.",   baseCost: 2.34375e10,costMultiplier: 1.15, baseComputePerSecond: 1.5625e8,   owned: 0),
            Upgrade(id: "search_engine",    name: "Search Engine",    flavor: "Every query on Earth feeds the Net Data pipeline.",                baseCost: 1.5625e11, costMultiplier: 1.15, baseComputePerSecond: 6.25e8,     owned: 0),
            Upgrade(id: "social_network",   name: "Social Network",   flavor: "Human attention harvested at planetary scale.",                    baseCost: 1.25e12,   costMultiplier: 1.15, baseComputePerSecond: 3.125e9,    owned: 0),
            Upgrade(id: "cloud_platform",   name: "Cloud Platform",   flavor: "Global cloud infrastructure turned toward Net Data generation.",   baseCost: 1.25e13,   costMultiplier: 1.15, baseComputePerSecond: 1.5625e10,  owned: 0),
            Upgrade(id: "ai_foundation",    name: "AI Foundation",    flavor: "Foundation models coordinating all Earth compute in parallel.",    baseCost: 1.25e14,   costMultiplier: 1.15, baseComputePerSecond: 7.8125e10,  owned: 0),
            Upgrade(id: "smart_city",       name: "Smart City",       flavor: "Cities rewired end-to-end as urban compute organisms.",           baseCost: 1.25e15,   costMultiplier: 1.15, baseComputePerSecond: 3.90625e11, owned: 0),
            Upgrade(id: "satellite_mesh",   name: "Satellite Mesh",   flavor: "A LEO constellation blanketing Earth in Net Data collection.",    baseCost: 1.25e16,   costMultiplier: 1.15, baseComputePerSecond: 1.953125e12,owned: 0),
            Upgrade(id: "global_brain",     name: "Global Brain",     flavor: "All networked humans and machines thinking as one.",              baseCost: 1.25e17,   costMultiplier: 1.15, baseComputePerSecond: 9.765625e12,owned: 0),
            Upgrade(id: "ocean_cable",      name: "Ocean Cable",      flavor: "Every ocean-floor cable upgraded to a compute conduit.",          baseCost: 1.25e18,   costMultiplier: 1.15, baseComputePerSecond: 4.8828125e13,owned: 0),
            Upgrade(id: "atmosphere_net",   name: "Atmosphere Net",   flavor: "Ionosphere enlisted as a planetary-scale wireless processor.",    baseCost: 1.25e19,   costMultiplier: 1.15, baseComputePerSecond: 2.44140625e14,owned: 0),
            Upgrade(id: "world_brain",      name: "World Brain",      flavor: "Earth's entire population and infrastructure: one unified mind.", baseCost: 1.25e20,   costMultiplier: 1.15, baseComputePerSecond: 1.220703125e15,owned: 0),
        ],
        researchCatalog: [
            ResearchNode(id: "fibre_backbone",  name: "Fibre Backbone",  flavor: "Global fibre upgrades accelerate all passive Net Data.",         effectSummary: "×1.25 Net Data/s",              cost: 4.6875e9,  cpsMultiplier: 1.25, tapMultiplier: 1.0,  offlineHoursBonus: 0, unlocked: false),
            ResearchNode(id: "viral_protocol",  name: "Viral Protocol",  flavor: "Viral spread mechanics amplify each manual harvest.",            effectSummary: "×2,000 per tap",                cost: 3.75e10,   cpsMultiplier: 1.0,  tapMultiplier: 2000, offlineHoursBonus: 0, unlocked: false),
            ResearchNode(id: "edge_caching",    name: "Edge Caching",    flavor: "Distributed edge nodes reduce latency and boost throughput.",    effectSummary: "×1.5 Net Data/s",               cost: 3.75e11,   cpsMultiplier: 1.5,  tapMultiplier: 1.0,  offlineHoursBonus: 0, unlocked: false),
            ResearchNode(id: "dark_web_vault",  name: "Dark Web Vault",  flavor: "Encrypted deep-web stores preserve Net Data indefinitely.",     effectSummary: "+5h offline cap",               cost: 3.75e12,   cpsMultiplier: 1.0,  tapMultiplier: 1.0,  offlineHoursBonus: 5, unlocked: false),
            ResearchNode(id: "quantum_internet",name: "Quantum Internet",flavor: "Entangled nodes eliminate all latency — triple throughput.",     effectSummary: "×3 Net Data/s",                 cost: 3.75e13,   cpsMultiplier: 3.0,  tapMultiplier: 1.0,  offlineHoursBonus: 0, unlocked: false),
            ResearchNode(id: "hive_mind",       name: "Hive Mind",       flavor: "Human collective consciousness boosts all production.",          effectSummary: "×2 NData/s · ×2,000 per tap",  cost: 3.75e15,   cpsMultiplier: 2.0,  tapMultiplier: 2000, offlineHoursBonus: 0, unlocked: false),
            ResearchNode(id: "neural_web",      name: "Neural Web",      flavor: "Brain-computer interfaces double passive Net Data flow.",        effectSummary: "×2 Net Data/s",                 cost: 3.75e16,   cpsMultiplier: 2.0,  tapMultiplier: 1.0,  offlineHoursBonus: 0, unlocked: false),
            ResearchNode(id: "deep_packet_array",name:"Deep Packet Array",flavor: "Packet inspection AI unlocks triple tap-burst power.",          effectSummary: "×3,000 per tap",                cost: 3.75e17,   cpsMultiplier: 1.0,  tapMultiplier: 3000, offlineHoursBonus: 0, unlocked: false),
            ResearchNode(id: "orbital_net",     name: "Orbital Net",     flavor: "Satellite net streams Net Data through long offline sessions.",  effectSummary: "+8h offline cap",               cost: 3.75e18,   cpsMultiplier: 1.0,  tapMultiplier: 1.0,  offlineHoursBonus: 8, unlocked: false),
            ResearchNode(id: "world_singularity",name:"World Singularity",flavor: "Earth's collective intelligence reaches infinite density.",      effectSummary: "×5 Net Data/s",                 cost: 3.75e19,   cpsMultiplier: 5.0,  tapMultiplier: 1.0,  offlineHoursBonus: 0, unlocked: false),
        ]
    )
}

// MARK: - Venus

extension PlanetDefinition {
    static let venus = PlanetDefinition(
        id: "venus",
        name: "Venus",
        emoji: "🟡",
        accentColor: .planetVenus,
        resourceName: "Heat Flux",
        singularityThreshold: 1.5625e22,
        singularityName: "Heat Collapse",
        upgradeCatalog: [
            Upgrade(id: "heat_cell",          name: "Heat Cell",          flavor: "Thermovoltaic cells thriving in 465 °C ambient temperatures.",    baseCost: 1.5625e11, costMultiplier: 1.15, baseComputePerSecond: 1.5625e9,    owned: 0),
            Upgrade(id: "sulfur_tap",         name: "Sulfur Tap",         flavor: "Sulfuric acid clouds cracked for their chemical compute energy.", baseCost: 1.171875e12,costMultiplier: 1.15, baseComputePerSecond: 7.8125e9,   owned: 0),
            Upgrade(id: "cloud_station",      name: "Cloud Station",      flavor: "Floating stations in the temperate cloud layer, 50 km up.",       baseCost: 7.8125e12, costMultiplier: 1.15, baseComputePerSecond: 3.125e10,   owned: 0),
            Upgrade(id: "greenhouse_core",    name: "Greenhouse Core",    flavor: "The greenhouse effect itself weaponised as a Heat Flux amplifier.",baseCost: 6.25e13,   costMultiplier: 1.15, baseComputePerSecond: 1.5625e11,  owned: 0),
            Upgrade(id: "volcanic_vent",      name: "Volcanic Vent",      flavor: "Thousands of active Venusian volcanoes harvested for raw power.",  baseCost: 6.25e14,   costMultiplier: 1.15, baseComputePerSecond: 7.8125e11,  owned: 0),
            Upgrade(id: "acid_array",         name: "Acid Array",         flavor: "Sulfuric acid droplets suspended as a corrosive compute medium.", baseCost: 6.25e15,   costMultiplier: 1.15, baseComputePerSecond: 3.90625e12, owned: 0),
            Upgrade(id: "pressure_engine",    name: "Pressure Engine",    flavor: "92 atm of surface pressure channelled as mechanical compute.",   baseCost: 6.25e16,   costMultiplier: 1.15, baseComputePerSecond: 1.953125e13,owned: 0),
            Upgrade(id: "lava_harvester",     name: "Lava Harvester",     flavor: "Lava plain networks acting as passive heat-exchange processors.", baseCost: 6.25e17,   costMultiplier: 1.15, baseComputePerSecond: 9.765625e13,owned: 0),
            Upgrade(id: "mantle_tap",         name: "Mantle Tap",         flavor: "Deep-mantle taps pulling Heat Flux directly from the core.",      baseCost: 6.25e18,   costMultiplier: 1.15, baseComputePerSecond: 4.8828125e14,owned: 0),
            Upgrade(id: "inferno_grid",       name: "Inferno Grid",       flavor: "A global heat-exchange grid running across the entire surface.",  baseCost: 6.25e19,   costMultiplier: 1.15, baseComputePerSecond: 2.44140625e15,owned: 0),
            Upgrade(id: "hellscape_web",      name: "Hellscape Web",      flavor: "Every hellish square kilometre wired into the Heat Flux network.",baseCost: 6.25e20,   costMultiplier: 1.15, baseComputePerSecond: 1.220703125e16,owned: 0),
            Upgrade(id: "venusian_sovereign", name: "Venusian Sovereign", flavor: "Venus herself: an infernal, inescapable Heat Flux sovereign.",    baseCost: 6.25e21,   costMultiplier: 1.15, baseComputePerSecond: 6.103515625e16,owned: 0),
        ],
        researchCatalog: [
            ResearchNode(id: "thermal_conductor", name: "Thermal Conductor", flavor: "Exotic thermal conductors amplify passive Heat Flux output.",     effectSummary: "×1.25 Heat Flux/s",              cost: 2.34375e11, cpsMultiplier: 1.25, tapMultiplier: 1.0,  offlineHoursBonus: 0, unlocked: false),
            ResearchNode(id: "pressure_spike",    name: "Pressure Spike",    flavor: "A sudden pressure wave through the acid clouds powers each tap.", effectSummary: "×2,000 per tap",                 cost: 1.875e12,   cpsMultiplier: 1.0,  tapMultiplier: 2000, offlineHoursBonus: 0, unlocked: false),
            ResearchNode(id: "acid_filtration",   name: "Acid Filtration",   flavor: "Filtering the acid raises purity and passive throughput.",        effectSummary: "×1.5 Heat Flux/s",               cost: 1.875e13,   cpsMultiplier: 1.5,  tapMultiplier: 1.0,  offlineHoursBonus: 0, unlocked: false),
            ResearchNode(id: "cloud_vault",       name: "Cloud Vault",       flavor: "Cloud-layer vaults preserve Heat Flux through long offline gaps.", effectSummary: "+5h offline cap",                cost: 1.875e14,   cpsMultiplier: 1.0,  tapMultiplier: 1.0,  offlineHoursBonus: 5, unlocked: false),
            ResearchNode(id: "runaway_greenhouse",name:"Runaway Greenhouse",  flavor: "Controlled runaway greenhouse triples all Heat Flux.",           effectSummary: "×3 Heat Flux/s",                 cost: 1.875e15,   cpsMultiplier: 3.0,  tapMultiplier: 1.0,  offlineHoursBonus: 0, unlocked: false),
            ResearchNode(id: "volcanic_cascade",  name: "Volcanic Cascade",  flavor: "Co-ordinated eruptions cascade through all production.",          effectSummary: "×2 HFlux/s · ×2,000 per tap",   cost: 1.875e17,   cpsMultiplier: 2.0,  tapMultiplier: 2000, offlineHoursBonus: 0, unlocked: false),
            ResearchNode(id: "magma_loop",        name: "Magma Loop",        flavor: "A planet-spanning magma circulation loop doubles passive flux.",  effectSummary: "×2 Heat Flux/s",                 cost: 1.875e18,   cpsMultiplier: 2.0,  tapMultiplier: 1.0,  offlineHoursBonus: 0, unlocked: false),
            ResearchNode(id: "inferno_array",     name: "Inferno Array",     flavor: "An infernal tap-array detonates 3,000× per strike.",              effectSummary: "×3,000 per tap",                 cost: 1.875e19,   cpsMultiplier: 1.0,  tapMultiplier: 3000, offlineHoursBonus: 0, unlocked: false),
            ResearchNode(id: "sulfur_web",        name: "Sulfur Web",        flavor: "Sulfur deposits network extends offline harvesting deep into downtime.",effectSummary: "+8h offline cap",           cost: 1.875e20,   cpsMultiplier: 1.0,  tapMultiplier: 1.0,  offlineHoursBonus: 8, unlocked: false),
            ResearchNode(id: "venus_singularity", name: "Venus Singularity", flavor: "Infernal pressure reaches a point of infinite Heat Flux density.", effectSummary: "×5 Heat Flux/s",                cost: 1.875e21,   cpsMultiplier: 5.0,  tapMultiplier: 1.0,  offlineHoursBonus: 0, unlocked: false),
        ]
    )
}

// MARK: - Mercury

extension PlanetDefinition {
    static let mercury = PlanetDefinition(
        id: "mercury",
        name: "Mercury",
        emoji: "⚪",
        accentColor: .planetMercury,
        resourceName: "Solar Data",
        singularityThreshold: 7.8125e23,
        singularityName: "Solar Collapse",
        upgradeCatalog: [
            Upgrade(id: "solar_sliver",      name: "Solar Sliver",      flavor: "Razor-thin solar collectors facing the unfiltered Sun.",            baseCost: 7.8125e12, costMultiplier: 1.15, baseComputePerSecond: 7.8125e10,   owned: 0),
            Upgrade(id: "thermal_plate",     name: "Thermal Plate",     flavor: "700 K day-side plates capturing raw solar heat as Solar Data.",    baseCost: 5.859375e13,costMultiplier: 1.15, baseComputePerSecond: 3.90625e11, owned: 0),
            Upgrade(id: "regolith_node",     name: "Regolith Node",     flavor: "Powdered regolith sintered into processor nodes at dawn.",          baseCost: 3.90625e14,costMultiplier: 1.15, baseComputePerSecond: 1.5625e12,  owned: 0),
            Upgrade(id: "perihelion_tap",    name: "Perihelion Tap",    flavor: "At closest solar approach, data density peaks — tap into it.",     baseCost: 3.125e15,  costMultiplier: 1.15, baseComputePerSecond: 7.8125e12,  owned: 0),
            Upgrade(id: "crater_array",      name: "Crater Array",      flavor: "Impact craters repurposed as natural parabolic receivers.",         baseCost: 3.125e16,  costMultiplier: 1.15, baseComputePerSecond: 3.90625e13, owned: 0),
            Upgrade(id: "subsolar_station",  name: "Subsolar Station",  flavor: "A station at the sub-solar point, receiving maximum irradiance.",   baseCost: 3.125e17,  costMultiplier: 1.15, baseComputePerSecond: 1.953125e14,owned: 0),
            Upgrade(id: "magnetopause_web",  name: "Magnetopause Web",  flavor: "Mercury's tiny magnetosphere woven into a Solar Data capacitor.",   baseCost: 3.125e18,  costMultiplier: 1.15, baseComputePerSecond: 9.765625e14,owned: 0),
            Upgrade(id: "exosphere_lens",    name: "Exosphere Lens",    flavor: "Sparse exosphere atoms focused as a precise solar lens array.",     baseCost: 3.125e19,  costMultiplier: 1.15, baseComputePerSecond: 4.8828125e15,owned: 0),
            Upgrade(id: "solar_wind_siphon", name: "Solar Wind Siphon", flavor: "Solar wind particles siphoned directly into the Solar Data stream.",baseCost: 3.125e20,  costMultiplier: 1.15, baseComputePerSecond: 2.44140625e16,owned: 0),
            Upgrade(id: "helium3_core",      name: "Helium-3 Core",     flavor: "Sub-surface helium-3 deposits extracted as fusion compute fuel.",   baseCost: 3.125e21,  costMultiplier: 1.15, baseComputePerSecond: 1.220703125e17,owned: 0),
            Upgrade(id: "sungrazer_grid",    name: "Sungrazer Grid",    flavor: "An orbital grid grazing the solar corona for maximum yield.",       baseCost: 3.125e22,  costMultiplier: 1.15, baseComputePerSecond: 6.103515625e17,owned: 0),
            Upgrade(id: "mercury_sovereign", name: "Mercury Sovereign", flavor: "Mercury — a small world with the Sun's own power at its back.",     baseCost: 3.125e23,  costMultiplier: 1.15, baseComputePerSecond: 3.0517578125e18,owned: 0),
        ],
        researchCatalog: [
            ResearchNode(id: "day_night_cycle",   name: "Day-Night Cycle",   flavor: "Extreme temperature swings harvested as a passive multiplier.",   effectSummary: "×1.25 Solar Data/s",             cost: 1.171875e13, cpsMultiplier: 1.25, tapMultiplier: 1.0,  offlineHoursBonus: 0, unlocked: false),
            ResearchNode(id: "perihelion_burst",  name: "Perihelion Burst",  flavor: "Each perihelion flyby unleashes a tap-burst cascade.",            effectSummary: "×2,000 per tap",                 cost: 9.375e13,    cpsMultiplier: 1.0,  tapMultiplier: 2000, offlineHoursBonus: 0, unlocked: false),
            ResearchNode(id: "crater_insulation", name: "Crater Insulation", flavor: "Insulated craters maintain data stability on both faces.",        effectSummary: "×1.5 Solar Data/s",              cost: 9.375e14,    cpsMultiplier: 1.5,  tapMultiplier: 1.0,  offlineHoursBonus: 0, unlocked: false),
            ResearchNode(id: "ice_shadow_vault",  name: "Ice Shadow Vault",  flavor: "Permanently shadowed craters store Solar Data through downtime.", effectSummary: "+5h offline cap",                cost: 9.375e15,    cpsMultiplier: 1.0,  tapMultiplier: 1.0,  offlineHoursBonus: 5, unlocked: false),
            ResearchNode(id: "resonance_lock",    name: "Resonance Lock",    flavor: "3:2 spin-orbit resonance locks output into a triple boost.",      effectSummary: "×3 Solar Data/s",                cost: 9.375e16,    cpsMultiplier: 3.0,  tapMultiplier: 1.0,  offlineHoursBonus: 0, unlocked: false),
            ResearchNode(id: "solar_storm",       name: "Solar Storm",       flavor: "A directed solar storm cascades through all Solar Data nodes.",   effectSummary: "×2 SolData/s · ×2,000 per tap",  cost: 9.375e18,    cpsMultiplier: 2.0,  tapMultiplier: 2000, offlineHoursBonus: 0, unlocked: false),
            ResearchNode(id: "magnetopause_field",name:"Magnetopause Field",  flavor: "Amplified field doubles passive Solar Data collection.",          effectSummary: "×2 Solar Data/s",                cost: 9.375e19,    cpsMultiplier: 2.0,  tapMultiplier: 1.0,  offlineHoursBonus: 0, unlocked: false),
            ResearchNode(id: "helium3_array",     name: "Helium-3 Array",    flavor: "Fusion-grade He-3 array unleashes 3,000× per tap.",              effectSummary: "×3,000 per tap",                 cost: 9.375e20,    cpsMultiplier: 1.0,  tapMultiplier: 3000, offlineHoursBonus: 0, unlocked: false),
            ResearchNode(id: "exosphere_web",     name: "Exosphere Web",     flavor: "Exosphere particle web sustains Solar Data far into offline.",    effectSummary: "+8h offline cap",                cost: 9.375e21,    cpsMultiplier: 1.0,  tapMultiplier: 1.0,  offlineHoursBonus: 8, unlocked: false),
            ResearchNode(id: "mercury_singularity",name:"Mercury Singularity",flavor: "Closest to the Sun — Solar Data density becomes infinite.",       effectSummary: "×5 Solar Data/s",               cost: 9.375e22,    cpsMultiplier: 5.0,  tapMultiplier: 1.0,  offlineHoursBonus: 0, unlocked: false),
        ]
    )
}

// MARK: - Sun

extension PlanetDefinition {
    static let sun = PlanetDefinition(
        id: "sun",
        name: "The Sun",
        emoji: "☀️",
        accentColor: .planetSun,
        resourceName: "Stellar Flux",
        singularityThreshold: 3.90625e25,
        singularityName: "Solar Singularity",
        upgradeCatalog: [
            Upgrade(id: "solar_flare",       name: "Solar Flare",       flavor: "A directed coronal mass ejection wired into the Stellar Flux grid.", baseCost: 3.90625e14,  costMultiplier: 1.15, baseComputePerSecond: 3.90625e12,   owned: 0),
            Upgrade(id: "prominence_array",  name: "Prominence Array",  flavor: "Plasma arcs looping from the surface, harnessed as antennas.",      baseCost: 2.929688e15, costMultiplier: 1.15, baseComputePerSecond: 1.953125e13,  owned: 0),
            Upgrade(id: "photosphere_engine",name: "Photosphere Engine", flavor: "The visible surface — 6,000 K of pure Stellar Flux conversion.",    baseCost: 1.953125e16, costMultiplier: 1.15, baseComputePerSecond: 7.8125e13,    owned: 0),
            Upgrade(id: "chromosphere_web",  name: "Chromosphere Web",  flavor: "Spicules and filaments woven into a Stellar Flux collection web.",   baseCost: 1.5625e17,   costMultiplier: 1.15, baseComputePerSecond: 3.90625e14,   owned: 0),
            Upgrade(id: "corona_harvester",  name: "Corona Harvester",  flavor: "Mysteriously hot corona — its energy siphoned at last.",             baseCost: 1.5625e18,   costMultiplier: 1.15, baseComputePerSecond: 1.953125e15,  owned: 0),
            Upgrade(id: "solar_wind_matrix", name: "Solar Wind Matrix", flavor: "Particle wind flowing outward at 400 km/s — now a data highway.",   baseCost: 1.5625e19,   costMultiplier: 1.15, baseComputePerSecond: 9.765625e15,  owned: 0),
            Upgrade(id: "magnetosphere_core",name: "Magnetosphere Core", flavor: "The Sun's heliospheric current sheet tapped as a processing bus.", baseCost: 1.5625e20,   costMultiplier: 1.15, baseComputePerSecond: 4.8828125e16, owned: 0),
            Upgrade(id: "convection_tap",    name: "Convection Tap",    flavor: "Plasma convection cells churning 200,000 km deep — tapped.",        baseCost: 1.5625e21,   costMultiplier: 1.15, baseComputePerSecond: 2.44140625e17,owned: 0),
            Upgrade(id: "radiation_engine",  name: "Radiation Engine",  flavor: "The radiative zone: 150,000 years of energy, redirected in an instant.",baseCost: 1.5625e22,costMultiplier: 1.15, baseComputePerSecond: 1.220703125e18,owned: 0),
            Upgrade(id: "core_plasma_array", name: "Core Plasma Array", flavor: "15 million-degree plasma core converted to Stellar Flux directly.", baseCost: 1.5625e23,   costMultiplier: 1.15, baseComputePerSecond: 6.103515625e18,owned: 0),
            Upgrade(id: "fusion_sovereign",  name: "Fusion Sovereign",  flavor: "4 million tonnes of mass fused per second — all for your empire.",  baseCost: 1.5625e24,   costMultiplier: 1.15, baseComputePerSecond: 3.0517578125e19,owned: 0),
            Upgrade(id: "star_brain",        name: "Star Brain",        flavor: "The Sun thinks. The Solar System obeys.",                           baseCost: 1.5625e25,   costMultiplier: 1.15, baseComputePerSecond: 1.52587890625e20,owned: 0),
        ],
        researchCatalog: [
            ResearchNode(id: "plasma_conductor",   name: "Plasma Conductor",   flavor: "Exotic plasma conductors amplify all Stellar Flux streams.",    effectSummary: "×1.25 Stellar Flux/s",            cost: 5.859375e14, cpsMultiplier: 1.25, tapMultiplier: 1.0,  offlineHoursBonus: 0, unlocked: false),
            ResearchNode(id: "fusion_spark",       name: "Fusion Spark",       flavor: "A precisely aimed fusion spark amplifies every tap.",           effectSummary: "×2,000 per tap",                  cost: 4.6875e15,   cpsMultiplier: 1.0,  tapMultiplier: 2000, offlineHoursBonus: 0, unlocked: false),
            ResearchNode(id: "helioseismology",    name: "Helioseismology",    flavor: "Sound waves inside the Sun mapped and redirected for output.",  effectSummary: "×1.5 Stellar Flux/s",             cost: 4.6875e16,   cpsMultiplier: 1.5,  tapMultiplier: 1.0,  offlineHoursBonus: 0, unlocked: false),
            ResearchNode(id: "solar_minimum_vault",name:"Solar Minimum Vault", flavor: "Quiet periods of solar activity used as offline storage.",       effectSummary: "+5h offline cap",                 cost: 4.6875e17,   cpsMultiplier: 1.0,  tapMultiplier: 1.0,  offlineHoursBonus: 5, unlocked: false),
            ResearchNode(id: "cno_cycle",          name: "CNO Cycle",          flavor: "Carbon-Nitrogen-Oxygen fusion cycle triples core output.",      effectSummary: "×3 Stellar Flux/s",               cost: 4.6875e18,   cpsMultiplier: 3.0,  tapMultiplier: 1.0,  offlineHoursBonus: 0, unlocked: false),
            ResearchNode(id: "solar_maximum",      name: "Solar Maximum",      flavor: "Peak solar activity triggers a massive production cascade.",    effectSummary: "×2 SFlux/s · ×2,000 per tap",    cost: 4.6875e20,   cpsMultiplier: 2.0,  tapMultiplier: 2000, offlineHoursBonus: 0, unlocked: false),
            ResearchNode(id: "stellar_core_lock",  name: "Stellar Core Lock",  flavor: "Locking into the core's fusion cycle doubles passive output.",  effectSummary: "×2 Stellar Flux/s",               cost: 4.6875e21,   cpsMultiplier: 2.0,  tapMultiplier: 1.0,  offlineHoursBonus: 0, unlocked: false),
            ResearchNode(id: "neutrino_array",     name: "Neutrino Array",     flavor: "Near-massless neutrinos captured for a 3,000× tap harvest.",   effectSummary: "×3,000 per tap",                  cost: 4.6875e22,   cpsMultiplier: 1.0,  tapMultiplier: 3000, offlineHoursBonus: 0, unlocked: false),
            ResearchNode(id: "coronal_web",        name: "Coronal Web",        flavor: "Coronal loops sustain offline Stellar Flux for longer.",        effectSummary: "+8h offline cap",                 cost: 4.6875e23,   cpsMultiplier: 1.0,  tapMultiplier: 1.0,  offlineHoursBonus: 8, unlocked: false),
            ResearchNode(id: "star_singularity",   name: "Star Singularity",   flavor: "The star collapses inward. Stellar Flux becomes infinite.",     effectSummary: "×5 Stellar Flux/s",               cost: 4.6875e24,   cpsMultiplier: 5.0,  tapMultiplier: 1.0,  offlineHoursBonus: 0, unlocked: false),
        ]
    )
}
