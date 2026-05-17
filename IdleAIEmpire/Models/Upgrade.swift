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
            baseCost: 100,
            costMultiplier: 1.15,
            baseComputePerSecond: 0.5,
            owned: 0
        ),
        Upgrade(
            id: "data_centre",
            name: "Data Centre",
            flavor: "An entire building dedicated to compute.",
            baseCost: 1_000,
            costMultiplier: 1.15,
            baseComputePerSecond: 3.0,
            owned: 0
        ),
    ]
}
