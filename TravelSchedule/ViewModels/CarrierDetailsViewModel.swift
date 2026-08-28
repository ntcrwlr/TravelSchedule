import Combine
import Foundation

@MainActor
final class CarrierDetailsViewModel: ObservableObject {
    @Published private(set) var state: CarrierDetailsState = .idle

    let carrierCode: String

    init(carrierCode: String) {
        self.carrierCode = carrierCode
    }

    func load() async {
        state = .loading
        AppErrorCenter.shared.report(nil)

        do {
            let details = try await NetworkClient.shared.fetchCarrierDetails(code: carrierCode)
            if let logoURL = details.logoURL {
                _ = await CarrierImageCache.shared.loadImage(from: logoURL)
            }
            state = .loaded(details)
            AppErrorCenter.shared.report(nil)
        } catch is CancellationError {
            return
        } catch {
            if (error as? URLError)?.code == .cancelled {
                return
            }
            let loadError = AppLoadError(error: error)
            state = .failed(loadError)
            AppErrorCenter.shared.report(loadError)
        }
    }
}
