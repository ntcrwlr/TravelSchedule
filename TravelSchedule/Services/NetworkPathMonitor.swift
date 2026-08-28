import Foundation
import Network

enum NetworkPathMonitor: Sendable {
    nonisolated static func connectivityUpdates() -> AsyncStream<Bool> {
        AsyncStream { continuation in
            let monitor = NWPathMonitor()
            monitor.pathUpdateHandler = { path in
                continuation.yield(path.status == .satisfied)
            }
            monitor.start(queue: DispatchQueue(label: "ru.practicum.travelschedule.network.monitor"))
            continuation.onTermination = { _ in
                monitor.cancel()
            }
        }
    }

    nonisolated static func currentConnectivity() async -> Bool {
        await withCheckedContinuation { continuation in
            let monitor = NWPathMonitor()
            monitor.pathUpdateHandler = { path in
                monitor.cancel()
                continuation.resume(returning: path.status == .satisfied)
            }
            monitor.start(queue: DispatchQueue(label: "ru.practicum.travelschedule.network.snapshot"))
        }
    }
}
