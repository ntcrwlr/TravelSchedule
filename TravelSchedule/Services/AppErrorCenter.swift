import Combine
import Foundation
import Network

@MainActor
final class AppErrorCenter: ObservableObject {
    static let shared = AppErrorCenter()

    @Published private(set) var error: AppLoadError?

    private var requestError: AppLoadError?
    private var isOffline = false
    private let monitor = NWPathMonitor()

    private init() {
        setupMonitor()
    }

    func report(_ error: AppLoadError?) {
        requestError = error
        publish()
    }

    private func setupMonitor() {
        monitor.pathUpdateHandler = { [weak self] path in
            let offline = path.status != .satisfied
            Task { @MainActor in
                self?.isOffline = offline
                self?.publish()
            }
        }
        monitor.start(queue: DispatchQueue(label: "ru.practicum.travelschedule.network"))
    }

    private func publish() {
        if isOffline {
            error = .noInternet
        } else {
            error = requestError
        }
    }
}
