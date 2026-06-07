import SwiftUI

struct EventDefinition {
    let id: String
    let name: String
    let emoji: String
    let month: Int
    let accentColor: Color
    let resourceName: String
    let singularityThreshold: Double
    let singularityName: String
    let upgradeCatalog: [Upgrade]
    let researchCatalog: [ResearchNode]

    // Always append new events — never reorder. Index must align with saved EventBoard array.
    static let all: [EventDefinition] = [june]
}

// MARK: - June — Midsummer Bloom

extension EventDefinition {
    static let june = EventDefinition(
        id: "june",
        name: "Midsummer Bloom",
        emoji: "🌸",
        month: 6,
        accentColor: .eventJune,
        resourceName: "Bloom Energy",
        singularityThreshold: 1e8,
        singularityName: "Midsummer Convergence",
        upgradeCatalog: [
            Upgrade(id: "june_sunflower",  name: "Sunflower Panel",      flavor: "Giant sunflowers rotate to track the longest day of the year.",     baseCost: 10,        costMultiplier: 1.15, baseComputePerSecond: 0.1,      owned: 0),
            Upgrade(id: "june_bumblebee",  name: "Bumblebee Relay",       flavor: "A humming network of pollinators routing energy between flowers.",   baseCost: 75,        costMultiplier: 1.15, baseComputePerSecond: 0.5,      owned: 0),
            Upgrade(id: "june_wildflower", name: "Wildflower Meadow",     flavor: "Vast meadows in full bloom, each petal a micro-collector.",          baseCost: 500,       costMultiplier: 1.15, baseComputePerSecond: 2,        owned: 0),
            Upgrade(id: "june_solstice",   name: "Solstice Beacon",       flavor: "Ancient standing stones aligned to the solstice sun's peak power.", baseCost: 4_000,     costMultiplier: 1.15, baseComputePerSecond: 10,       owned: 0),
            Upgrade(id: "june_honeycomb",  name: "Honeycomb Grid",        flavor: "Hexagonal wax cells conducting Bloom Energy with perfect geometry.", baseCost: 40_000,    costMultiplier: 1.15, baseComputePerSecond: 50,       owned: 0),
            Upgrade(id: "june_maypole",    name: "Maypole Transmitter",   flavor: "Festival ribbons woven with conductive silk, broadcasting bloom.",   baseCost: 400_000,   costMultiplier: 1.15, baseComputePerSecond: 250,      owned: 0),
            Upgrade(id: "june_bonfire",    name: "Festival Bonfire",      flavor: "Midsummer bonfires channelling ancient bloom into raw energy.",       baseCost: 4_000_000, costMultiplier: 1.15, baseComputePerSecond: 1_250,    owned: 0),
            Upgrade(id: "june_dragonfly",  name: "Dragonfly Swarm",       flavor: "Iridescent wings harvest bloom frequencies unavailable to machines.", baseCost: 4e7,       costMultiplier: 1.15, baseComputePerSecond: 6_250,    owned: 0),
            Upgrade(id: "june_river",      name: "River Bloom Station",   flavor: "Riverbanks thick with reeds and flowers, slow energy made vast.",    baseCost: 4e8,       costMultiplier: 1.15, baseComputePerSecond: 31_250,   owned: 0),
            Upgrade(id: "june_oak",        name: "Oak Grove Network",     flavor: "Ancient oaks whose roots form a natural bloom distribution grid.",   baseCost: 4e9,       costMultiplier: 1.15, baseComputePerSecond: 156_250,  owned: 0),
            Upgrade(id: "june_aurora",     name: "Summer Aurora",         flavor: "Rare pale aurora of the solstice night — pure bloom crystallised.",  baseCost: 4e10,      costMultiplier: 1.15, baseComputePerSecond: 781_250,  owned: 0),
            Upgrade(id: "june_crown",      name: "Midsummer Crown",       flavor: "The crown of the year. All bloom converges here.",                  baseCost: 4e11,      costMultiplier: 1.15, baseComputePerSecond: 3_906_250, owned: 0),
        ],
        researchCatalog: [
            ResearchNode(id: "june_r_pollen",      name: "Pollen Surge",       flavor: "Pollen clouds carry Bloom Energy further than any wire.",          effectSummary: "×2 Bloom/s",                    cost: 1_500,    cpsMultiplier: 2.0,  tapMultiplier: 1.0,     offlineHoursBonus: 0, unlocked: false),
            ResearchNode(id: "june_r_bee",         name: "Bee Cascade",        flavor: "Waggle-dance choreography amplifies every tap a thousandfold.",    effectSummary: "×5,000 per tap",                cost: 12_000,   cpsMultiplier: 1.0,  tapMultiplier: 5000,    offlineHoursBonus: 0, unlocked: false),
            ResearchNode(id: "june_r_meadow",      name: "Meadow Bloom",       flavor: "Peak-summer meadows triple the passive Bloom Energy flow.",        effectSummary: "×3 Bloom/s",                    cost: 120_000,  cpsMultiplier: 3.0,  tapMultiplier: 1.0,     offlineHoursBonus: 0, unlocked: false),
            ResearchNode(id: "june_r_dew",         name: "Dew Collector",      flavor: "Dawn dew stores bloom overnight, extending offline yield.",         effectSummary: "+3h offline cap",               cost: 500_000,  cpsMultiplier: 1.0,  tapMultiplier: 1.0,     offlineHoursBonus: 3, unlocked: false),
            ResearchNode(id: "june_r_solstice",    name: "Solstice Surge",     flavor: "The longest day unlocks a ×5 burst of Bloom Energy.",              effectSummary: "×5 Bloom/s",                    cost: 1_200_000,cpsMultiplier: 5.0,  tapMultiplier: 1.0,     offlineHoursBonus: 0, unlocked: false),
            ResearchNode(id: "june_r_rain",        name: "Summer Rain",        flavor: "A warm midsummer shower that cascades through all production.",     effectSummary: "×5 BEng/s · ×5,000 per tap",   cost: 1.2e8,    cpsMultiplier: 5.0,  tapMultiplier: 5000,    offlineHoursBonus: 0, unlocked: false),
            ResearchNode(id: "june_r_golden",      name: "Golden Hour",        flavor: "The golden evening light triples passive Bloom Energy output.",     effectSummary: "×3 Bloom/s",                    cost: 1.2e9,    cpsMultiplier: 3.0,  tapMultiplier: 1.0,     offlineHoursBonus: 0, unlocked: false),
            ResearchNode(id: "june_r_firefly",     name: "Firefly Network",    flavor: "Firefly bio-luminescence decoded into ×10,000 tap power.",          effectSummary: "×10,000 per tap",               cost: 1.2e10,   cpsMultiplier: 1.0,  tapMultiplier: 10000,   offlineHoursBonus: 0, unlocked: false),
            ResearchNode(id: "june_r_vault",       name: "Night Sky Vault",    flavor: "Constellations of midsummer store Bloom while you sleep.",          effectSummary: "+5h offline cap",               cost: 1.2e11,   cpsMultiplier: 1.0,  tapMultiplier: 1.0,     offlineHoursBonus: 5, unlocked: false),
            ResearchNode(id: "june_r_twilight",    name: "Twilight Bloom",     flavor: "The lingering twilight of June quintuples passive production.",     effectSummary: "×5 Bloom/s",                    cost: 1.2e12,   cpsMultiplier: 5.0,  tapMultiplier: 1.0,     offlineHoursBonus: 0, unlocked: false),
            ResearchNode(id: "june_r_dawn",        name: "Dawn Cascade",       flavor: "The first light of midsummer floods every tap with power.",         effectSummary: "×10 Bloom/s",                   cost: 1.2e13,   cpsMultiplier: 10.0, tapMultiplier: 1.0,     offlineHoursBonus: 0, unlocked: false),
            ResearchNode(id: "june_r_dream",       name: "Midsummer Dream",    flavor: "A Shakespearean cascade of ×10,000 per tap enchants your taps.",    effectSummary: "×10,000 per tap",               cost: 1.2e14,   cpsMultiplier: 1.0,  tapMultiplier: 10000,   offlineHoursBonus: 0, unlocked: false),
            ResearchNode(id: "june_r_eternal",     name: "Eternal Daylight",   flavor: "The sun barely sets — offline bloom streams all through the night.", effectSummary: "+5h offline cap",               cost: 1.2e15,   cpsMultiplier: 1.0,  tapMultiplier: 1.0,     offlineHoursBonus: 5, unlocked: false),
            ResearchNode(id: "june_r_convergence", name: "Bloom Convergence",  flavor: "All bloom streams merge into a single ×10 torrent.",                effectSummary: "×10 Bloom/s",                   cost: 1.2e16,   cpsMultiplier: 10.0, tapMultiplier: 1.0,     offlineHoursBonus: 0, unlocked: false),
            ResearchNode(id: "june_r_grand",       name: "Grand Midsummer",    flavor: "The apex of the year — all of summer's power, ×20, unleashed.",     effectSummary: "×20 Bloom/s",                   cost: 1.2e17,   cpsMultiplier: 20.0, tapMultiplier: 1.0,     offlineHoursBonus: 0, unlocked: false),
        ]
    )
}
