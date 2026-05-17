import Foundation

struct Upgrade: Codable, Identifiable {
    let id: String
    let name: String
    let flavor: String
    let baseCost: Double
    let costMultiplier: Double
    let baseComputePerSecond: Double
    var owned: Int

    var cost: Double {
        baseCost * pow(costMultiplier, Double(owned))
    }

    var computePerSecond: Double {
        baseComputePerSecond * Double(owned)
    }

    // Starting catalog — new entries must be appended, never reordered,
    // to keep saved upgrade arrays aligned when decoding.
    static let catalog: [Upgrade] = [
        Upgrade(
            id: "gpu",
            name: "GPU",
            flavor: "A graphics card repurposed for AI compute.",
            baseCost: 10,
            costMultiplier: 1.15,
            baseComputePerSecond: 0.1,
            owned: 0
        ),
        Upgrade(
            id: "server_rack",
            name: "Server Rack",
            flavor: "A rack of servers humming in your garage.",
            baseCost: 75,
            costMultiplier: 1.15,
            baseComputePerSecond: 0.5,
            owned: 0
        ),
        Upgrade(
            id: "data_centre",
            name: "Data Centre",
            flavor: "An entire building dedicated to compute.",
            baseCost: 500,
            costMultiplier: 1.15,
            baseComputePerSecond: 2.0,
            owned: 0
        ),
        Upgrade(
            id: "ai_cluster",
            name: "AI Cluster",
            flavor: "Thousands of coordinated GPUs chasing a single objective.",
            baseCost: 4_000,
            costMultiplier: 1.15,
            baseComputePerSecond: 10.0,
            owned: 0
        ),
        Upgrade(
            id: "hyperscaler",
            name: "Hyperscaler",
            flavor: "A hyperscale facility running exaflops of AI workloads.",
            baseCost: 40_000,
            costMultiplier: 1.15,
            baseComputePerSecond: 50.0,
            owned: 0
        ),
        Upgrade(
            id: "quantum_core",
            name: "Quantum Core",
            flavor: "Qubits doing the work of a million classical chips.",
            baseCost: 400_000,
            costMultiplier: 1.15,
            baseComputePerSecond: 250.0,
            owned: 0
        ),
        Upgrade(
            id: "cooling_array",
            name: "Cooling Array",
            flavor: "Supercooled infrastructure keeping your empire from melting itself.",
            baseCost: 4_000_000,
            costMultiplier: 1.15,
            baseComputePerSecond: 1_250.0,
            owned: 0
        ),
        Upgrade(
            id: "ai_agent",
            name: "AI Agent",
            flavor: "An autonomous system that optimises compute faster than any human.",
            baseCost: 40_000_000,
            costMultiplier: 1.15,
            baseComputePerSecond: 6_250.0,
            owned: 0
        ),
        Upgrade(
            id: "neural_fabric",
            name: "Neural Fabric",
            flavor: "A self-organising substrate of interconnected neural processors.",
            baseCost: 400_000_000,
            costMultiplier: 1.15,
            baseComputePerSecond: 31_250.0,
            owned: 0
        ),
        Upgrade(
            id: "orbital_station",
            name: "Orbital Station",
            flavor: "A compute platform above the atmosphere, free from earthly limits.",
            baseCost: 4_000_000_000,
            costMultiplier: 1.15,
            baseComputePerSecond: 156_250.0,
            owned: 0
        ),
        Upgrade(
            id: "dyson_swarm",
            name: "Dyson Swarm",
            flavor: "Solar collectors blanketing the sun, powering exaflops around the clock.",
            baseCost: 40_000_000_000,
            costMultiplier: 1.15,
            baseComputePerSecond: 781_250.0,
            owned: 0
        ),
        Upgrade(
            id: "planetary_grid",
            name: "Planetary Grid",
            flavor: "The entire planet rewired as a single unified compute matrix.",
            baseCost: 400_000_000_000,
            costMultiplier: 1.15,
            baseComputePerSecond: 3_906_250.0,
            owned: 0
        ),
    ]
}
