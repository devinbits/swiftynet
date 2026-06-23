import Foundation

struct NetworkSnapshot: Sendable {
    let connectivity: ConnectivityState
    let primaryInterface: NetworkInterface?
    let allInterfaces: [NetworkInterface]
    let downloadSpeed: Double
    let uploadSpeed: Double

    static let empty = NetworkSnapshot(
        connectivity: .offline,
        primaryInterface: nil,
        allInterfaces: [],
        downloadSpeed: 0,
        uploadSpeed: 0
    )
}
