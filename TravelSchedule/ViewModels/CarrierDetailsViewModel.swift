import Combine
import Foundation

@MainActor
final class CarrierDetailsViewModel: ObservableObject {
    @Published private(set) var details: CarrierDetails?
    @Published private(set) var isLoading = false
    @Published private(set) var loadError: AppLoadError?

    let carrierCode: String

    init(carrierCode: String) {
        self.carrierCode = carrierCode
    }

    func load() async {
        isLoading = true
        loadError = nil
        AppErrorCenter.shared.report(nil)
        defer { isLoading = false }

        do {
            let details = try await CarrierService.fetchDetails(
                code: carrierCode,
                apikey: ApiKey.yandexRasp
            )
            if let logoURL = details.logoURL {
                _ = await CarrierImageCache.shared.image(from: logoURL)
            }
            self.details = details
            AppErrorCenter.shared.report(nil)
        } catch is CancellationError {
            return
        } catch {
            if (error as? URLError)?.code == .cancelled {
                return
            }
            let loadError = AppLoadError(error: error)
            self.loadError = loadError
            AppErrorCenter.shared.report(loadError)
            details = nil
        }
    }
}
