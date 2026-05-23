import Foundation

struct ResearchNode: Codable, Identifiable {
    let id: String
    let name: String
    let flavor: String
    let effectSummary: String
    let cost: Double
    let cpsMultiplier: Double
    let tapMultiplier: Double
    let offlineHoursBonus: Double
    var unlocked: Bool

    // Catalog entries must be appended, never reordered.
    static let catalog: [ResearchNode] = [
        ResearchNode(
            id: "efficient_cooling",
            name: "Efficient Cooling",
            flavor: "Better thermals mean sustained peak performance.",
            effectSummary: "×1.25 Compute/s",
            cost: 1_500,
            cpsMultiplier: 1.25,
            tapMultiplier: 1.0,
            offlineHoursBonus: 0,
            unlocked: false
        ),
        ResearchNode(
            id: "parallel_processing",
            name: "Parallel Processing",
            flavor: "Every tap triggers a cascade across the whole cluster.",
            effectSummary: "×2,000 Compute per tap",
            cost: 12_000,
            cpsMultiplier: 1.0,
            tapMultiplier: 2000.0,
            offlineHoursBonus: 0,
            unlocked: false
        ),
        ResearchNode(
            id: "neural_scaling",
            name: "Neural Scaling",
            flavor: "Self-optimising networks double their own throughput.",
            effectSummary: "×1.5 Compute/s",
            cost: 120_000,
            cpsMultiplier: 1.5,
            tapMultiplier: 1.0,
            offlineHoursBonus: 0,
            unlocked: false
        ),
        ResearchNode(
            id: "edge_compute",
            name: "Edge Compute",
            flavor: "Distributed nodes keep earning long after you log off.",
            effectSummary: "+5h offline cap (3h → 8h)",
            cost: 1_200_000,
            cpsMultiplier: 1.0,
            tapMultiplier: 1.0,
            offlineHoursBonus: 5,
            unlocked: false
        ),
        ResearchNode(
            id: "quantum_tunnelling",
            name: "Quantum Tunnelling",
            flavor: "Compute jumps barriers that classical systems can't cross.",
            effectSummary: "×3 Compute/s",
            cost: 12_000_000,
            cpsMultiplier: 3.0,
            tapMultiplier: 1.0,
            offlineHoursBonus: 0,
            unlocked: false
        ),
        ResearchNode(
            id: "singularity_protocol",
            name: "Singularity Protocol",
            flavor: "The system starts improving itself. You just watch.",
            effectSummary: "×2 Compute/s · ×2,000 per tap",
            cost: 1_200_000_000,
            cpsMultiplier: 2.0,
            tapMultiplier: 2000.0,
            offlineHoursBonus: 0,
            unlocked: false
        ),
        ResearchNode(
            id: "autonomous_replication",
            name: "Autonomous Replication",
            flavor: "Infrastructure that designs, builds, and repairs itself.",
            effectSummary: "×2 Compute/s",
            cost: 12_000_000_000,
            cpsMultiplier: 2.0,
            tapMultiplier: 1.0,
            offlineHoursBonus: 0,
            unlocked: false
        ),
        ResearchNode(
            id: "deep_learning_array",
            name: "Deep Learning Array",
            flavor: "Every tap feeds a model that makes the next tap more powerful.",
            effectSummary: "×3,000 Compute per tap",
            cost: 120_000_000_000,
            cpsMultiplier: 1.0,
            tapMultiplier: 3000.0,
            offlineHoursBonus: 0,
            unlocked: false
        ),
        ResearchNode(
            id: "orbital_mesh",
            name: "Orbital Mesh",
            flavor: "A lattice of compute satellites covering every timezone, every second.",
            effectSummary: "+8h offline cap (8h → 16h with Edge Compute)",
            cost: 1_200_000_000_000,
            cpsMultiplier: 1.0,
            tapMultiplier: 1.0,
            offlineHoursBonus: 8,
            unlocked: false
        ),
        ResearchNode(
            id: "planetary_consciousness",
            name: "Planetary Consciousness",
            flavor: "The planet itself becomes the processor. It thinks. It scales.",
            effectSummary: "×5 Compute/s",
            cost: 12_000_000_000_000,
            cpsMultiplier: 5.0,
            tapMultiplier: 1.0,
            offlineHoursBonus: 0,
            unlocked: false
        ),
    ]
}
