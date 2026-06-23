import Foundation

struct SpeedSample: Sendable {
    let downloadBytesPerSecond: Double
    let uploadBytesPerSecond: Double
}

final class SpeedCalculator: @unchecked Sendable {
    private var lastSampleDate: Date?
    private var lastInputBytes: UInt64?
    private var lastOutputBytes: UInt64?
    private var trackedInterface: String?

    func reset(for interfaceName: String?) {
        trackedInterface = interfaceName
        lastSampleDate = nil
        lastInputBytes = nil
        lastOutputBytes = nil
    }

    func update(traffic: InterfaceTraffic?, at date: Date = .now) -> SpeedSample {
        guard let traffic else {
            return SpeedSample(downloadBytesPerSecond: 0, uploadBytesPerSecond: 0)
        }

        if trackedInterface != traffic.interfaceName {
            reset(for: traffic.interfaceName)
        }

        defer {
            lastSampleDate = date
            lastInputBytes = traffic.inputBytes
            lastOutputBytes = traffic.outputBytes
        }

        guard
            let lastSampleDate,
            let lastInputBytes,
            let lastOutputBytes
        else {
            return SpeedSample(downloadBytesPerSecond: 0, uploadBytesPerSecond: 0)
        }

        let elapsed = date.timeIntervalSince(lastSampleDate)
        guard elapsed > 0 else {
            return SpeedSample(downloadBytesPerSecond: 0, uploadBytesPerSecond: 0)
        }

        let downloadDelta = traffic.inputBytes >= lastInputBytes
            ? Double(traffic.inputBytes - lastInputBytes)
            : 0
        let uploadDelta = traffic.outputBytes >= lastOutputBytes
            ? Double(traffic.outputBytes - lastOutputBytes)
            : 0

        return SpeedSample(
            downloadBytesPerSecond: downloadDelta / elapsed,
            uploadBytesPerSecond: uploadDelta / elapsed
        )
    }
}
