import Combine
import Foundation

@MainActor
final class CarriersListViewModel: ObservableObject {
    @Published private(set) var trips: [Trip] = []
    @Published private(set) var isLoading = false
    @Published private(set) var loadError: AppLoadError?
    @Published var filters = ScheduleFilters()

    @Published private(set) var from: RoutePoint?
    @Published private(set) var to: RoutePoint?

    var filteredTrips: [Trip] {
        trips.filter { filters.matches($0) }
    }

    var routeTitle: String {
        AppStrings.routeTitle(
            from: from?.title ?? AppStrings.from,
            to: to?.title ?? AppStrings.to
        )
    }

    init(from: RoutePoint? = nil, to: RoutePoint? = nil) {
        self.from = from
        self.to = to
    }

    func configure(from: RoutePoint?, to: RoutePoint?) {
        self.from = from
        self.to = to
    }

    func load() async {
        guard let from, let to else {
            trips = []
            return
        }

        isLoading = true
        loadError = nil
        AppErrorCenter.shared.report(nil)
        defer { isLoading = false }

        do {
            let client = try NetworkClient.make()
            let service = ScheduleBetweenStationsService(
                client: client,
                apikey: ApiKey.yandexRasp
            )
            trips = try await service.fetchTrips(
                from: from.id,
                to: to.id,
                date: Self.todayString()
            )
            isLoading = false
            AppErrorCenter.shared.report(nil)
            await loadMissingLogos()
        } catch is CancellationError {
            return
        } catch {
            if (error as? URLError)?.code == .cancelled {
                return
            }
            print("Schedule loading failed: \(error)")
            let loadError = AppLoadError(error: error)
            self.loadError = loadError
            AppErrorCenter.shared.report(loadError)
            trips = []
        }
    }

    private func loadMissingLogos() async {
        let codes = Set(trips.compactMap { trip -> String? in
            guard trip.logoURL == nil else { return nil }
            return trip.carrierCode
        })
        guard !codes.isEmpty else { return }

        var logos: [String: URL] = [:]
        await withTaskGroup(of: (String, URL?).self) { group in
            for code in codes {
                group.addTask {
                    let url = await CarrierService.fetchLogoURL(
                        code: code,
                        apikey: ApiKey.yandexRasp
                    )
                    if let url {
                        _ = await CarrierImageCache.shared.image(from: url)
                    }
                    return (code, url)
                }
            }
            for await (code, url) in group {
                if let url {
                    logos[code] = url
                }
            }
        }

        trips = trips.map { trip in
            guard trip.logoURL == nil,
                  let code = trip.carrierCode,
                  let url = logos[code]
            else {
                return trip
            }
            return trip.withLogoURL(url)
        }
    }

    private static func todayString() -> String {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: Date())
    }
}
