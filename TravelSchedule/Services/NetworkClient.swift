import Foundation
import OpenAPIRuntime
import OpenAPIURLSession

actor NetworkClient {
    static let shared = NetworkClient(apikey: ApiKey.yandexRasp)

    private let scheduleBetweenStationsService: ScheduleBetweenStationsService
    private let carrierService: CarrierService
    private let stationsListService: StationsListService
    private let scheduleOnStationService: ScheduleOnStationService
    private let nearestStationsService: NearestStationsService
    private let nearestSettlementService: NearestSettlementService
    private let copyrightService: CopyrightService
    private let threadService: ThreadService

    init(apikey: String) {
        let serverURL: URL
        do {
            serverURL = try Servers.Server1.url()
        } catch {
            assertionFailure("Failed to resolve Yandex Rasp server URL: \(error)")
            serverURL = URL(string: "https://api.rasp.yandex.net")!
        }

        let client = Client(
            serverURL: serverURL,
            transport: URLSessionTransport()
        )
        scheduleBetweenStationsService = ScheduleBetweenStationsService(client: client, apikey: apikey)
        carrierService = CarrierService(client: client, apikey: apikey)
        stationsListService = StationsListService(client: client, apikey: apikey)
        scheduleOnStationService = ScheduleOnStationService(client: client, apikey: apikey)
        nearestStationsService = NearestStationsService(client: client, apikey: apikey)
        nearestSettlementService = NearestSettlementService(client: client, apikey: apikey)
        copyrightService = CopyrightService(client: client, apikey: apikey)
        threadService = ThreadService(client: client, apikey: apikey)
    }

    func fetchTrips(from: String, to: String, date: String) async throws -> [Trip] {
        try await scheduleBetweenStationsService.fetchTrips(from: from, to: to, date: date)
    }

    func getScheduleBetweenStations(
        from: String,
        to: String,
        date: String?,
        transfers: Bool?
    ) async throws -> ScheduleBetweenStations {
        try await scheduleBetweenStationsService.getScheduleBetweenStations(
            from: from,
            to: to,
            date: date,
            transfers: transfers
        )
    }

    func fetchCarrierDetails(code: String) async throws -> CarrierDetails {
        try await carrierService.fetchDetails(code: code)
    }

    func fetchCarrierLogoURL(code: String) async -> URL? {
        try? await carrierService.fetchDetails(code: code).logoURL
    }

    func getCarrier(code: String) async throws -> CarrierInfo {
        try await carrierService.getCarrier(code: code)
    }

    func getStationsList() async throws -> StationsList {
        try await stationsListService.getStationsList()
    }

    func getScheduleOnStation(station: String) async throws -> ScheduleOnStation {
        try await scheduleOnStationService.getScheduleOnStation(station: station)
    }

    func getNearestStations(lat: Double, lng: Double, distance: Int) async throws -> NearestStations {
        try await nearestStationsService.getNearestStations(lat: lat, lng: lng, distance: distance)
    }

    func getNearestSettlement(lat: Double, lng: Double) async throws -> NearestSettlement {
        try await nearestSettlementService.getNearestSettlement(lat: lat, lng: lng)
    }

    func getCopyright() async throws -> CopyrightInfo {
        try await copyrightService.getCopyright()
    }

    func getThread(uid: String) async throws -> ThreadStations {
        try await threadService.getThread(uid: uid)
    }

    func downloadData(from url: URL) async throws -> Data {
        let (data, response) = try await URLSession.shared.data(from: url)
        let statusCode = (response as? HTTPURLResponse)?.statusCode ?? 0
        guard statusCode == HTTPStatusCode.ok else {
            throw URLError(.badServerResponse)
        }
        return data
    }

    func loadUserAgreementMarkdown() async -> String {
        if let remote = await fetchRemoteAgreementMarkdown() {
            return UserAgreementLoader.sanitize(remote)
        }
        if let local = UserAgreementLoader.loadBundledMarkdown() {
            return UserAgreementLoader.sanitize(local)
        }
        return ""
    }

    private func fetchRemoteAgreementMarkdown() async -> String? {
        do {
            let data = try await downloadData(from: UserAgreementLoader.remoteMarkdownURL)
            guard let text = String(data: data, encoding: .utf8), !text.isEmpty else {
                return nil
            }
            return text
        } catch {
            return nil
        }
    }
}
