import Combine
import Foundation

@MainActor
final class AppErrorCenter: ObservableObject {
    static let shared = AppErrorCenter()

    @Published private(set) var error: AppLoadError?

    private var requestError: AppLoadError?
    private var isOffline = false
    private var monitorTask: Task<Void, Never>?

    private init() {
        setupMonitor()
    }

    func report(_ error: AppLoadError?) {
        requestError = error
        publish()
    }

    private func setupMonitor() {
        monitorTask = Task { [weak self] in
            for await isOnline in NetworkPathMonitor.connectivityUpdates() {
                guard let self else { return }
                isOffline = !isOnline
                publish()
            }
        }
    }

    private func publish() {
        if isOffline {
            error = .noInternet
        } else {
            error = requestError
        }
    }
}
