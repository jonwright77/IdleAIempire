import Foundation

struct Achievement: Codable, Identifiable {
    let id: String
    let name: String
    let description: String
    let icon: String       // SF Symbol name
    var unlocked: Bool

    // Catalog entries must be appended, never reordered.
    static let catalog: [Achievement] = [
        Achievement(id: "first_gpu",         name: "First Boot",       description: "Buy your first GPU.",                         icon: "cpu",                               unlocked: false),
        Achievement(id: "first_server_rack", name: "Server Room",      description: "Buy your first Server Rack.",                 icon: "server.rack",                       unlocked: false),
        Achievement(id: "first_data_centre", name: "Data Baron",       description: "Buy your first Data Centre.",                 icon: "building.2.fill",                   unlocked: false),
        Achievement(id: "first_ai_cluster",  name: "Cluster Lord",     description: "Deploy your first AI Cluster.",               icon: "square.grid.3x3.fill",              unlocked: false),
        Achievement(id: "first_orbital",     name: "Going Orbital",    description: "Launch your first Orbital Station.",          icon: "antenna.radiowaves.left.and.right", unlocked: false),
        Achievement(id: "first_planetary",   name: "Planetary Scale",  description: "Build your first Planetary Grid.",            icon: "globe.americas.fill",               unlocked: false),
        Achievement(id: "auto_tapper",       name: "Always On",        description: "Unlock the Auto-Tapper (25 GPUs).",           icon: "bolt.fill",                         unlocked: false),
        Achievement(id: "first_research",    name: "First Insight",    description: "Unlock your first research node.",            icon: "magnifyingglass",                   unlocked: false),
        Achievement(id: "all_base_research", name: "Deep Thinker",     description: "Unlock the first 6 research nodes.",         icon: "lightbulb.fill",                    unlocked: false),
        Achievement(id: "compute_1k",        name: "1K Club",          description: "Accumulate 1,000 Compute.",                  icon: "chart.bar.fill",                    unlocked: false),
        Achievement(id: "compute_1m",        name: "Millionaire",      description: "Accumulate 1,000,000 Compute.",              icon: "chart.bar.fill",                    unlocked: false),
        Achievement(id: "compute_1b",        name: "Billionaire",      description: "Accumulate 1,000,000,000 Compute.",          icon: "chart.bar.fill",                    unlocked: false),
        Achievement(id: "compute_1t",        name: "Trillionaire",     description: "Accumulate 1,000,000,000,000 Compute.",      icon: "chart.line.uptrend.xyaxis",         unlocked: false),
        Achievement(id: "first_prestige",    name: "Transcendent",     description: "Perform your first Singularity.",            icon: "sparkles",                          unlocked: false),
        Achievement(id: "prestige_5",        name: "Eternal",          description: "Perform 5 Singularities.",                   icon: "infinity",                          unlocked: false),
        Achievement(id: "first_new_planet",  name: "Planet Hopper",    description: "Unlock a second planet.",                    icon: "globe.europe.africa.fill",          unlocked: false),
        Achievement(id: "all_planets",       name: "Solar Sovereign",  description: "Unlock all 9 planets.",                      icon: "sun.max.fill",                      unlocked: false),
    ]
}
