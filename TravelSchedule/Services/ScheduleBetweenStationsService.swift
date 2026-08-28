import Foundation
import OpenAPIRuntime
import OpenAPIURLSession

typealias ScheduleBetweenStations = Components.Schemas.SearchResponse

protocol ScheduleBetweenStationsServiceProtocol {
    func getScheduleBetweenStations(
        from: String,
        to: String,
        date: String?,
        transfers: Bool?
    ) async throws -> ScheduleBetweenStations
}

final class ScheduleBetweenStationsService: ScheduleBetweenStationsServiceProtocol {
    private let client: Client
    private let apikey: String

    init(client: Client, apikey: String) {
        self.client = client
        self.apikey = apikey
    }

    func getScheduleBetweenStations(
        from: String,
        to: String,
        date: String? = nil,
        transfers: Bool? = nil
    ) async throws -> ScheduleBetweenStations {
        let response = try await client.getScheduleBetweenStations(query: .init(
            apikey: apikey,
            from: from,
            to: to,
            date: date,
            transfers: transfers
        ))
        return try response.ok.body.json
    }

    func fetchTrips(
        from: String,
        to: String,
        date: String
    ) async throws -> [Trip] {
        var components = URLComponents(string: "https://api.rasp.yandex.net/v3.0/search/")
        components?.queryItems = [
            URLQueryItem(name: "apikey", value: apikey),
            URLQueryItem(name: "from", value: from),
            URLQueryItem(name: "to", value: to),
            URLQueryItem(name: "date", value: date),
            URLQueryItem(name: "transfers", value: "true"),
            URLQueryItem(name: "format", value: "json"),
            URLQueryItem(name: "lang", value: "ru_RU"),
            URLQueryItem(name: "limit", value: "40")
        ]

        guard let url = components?.url else {
            throw URLError(.badURL)
        }

        let (data, response) = try await URLSession.shared.data(from: url)
        let statusCode = (response as? HTTPURLResponse)?.statusCode ?? 0

        if statusCode == HTTPStatusCode.notFound || statusCode == HTTPStatusCode.badRequest {
            return []
        }

        guard statusCode == HTTPStatusCode.ok else {
            throw URLError(.badServerResponse)
        }

        return try Self.decodeTrips(from: data)
    }

    nonisolated private static func decodeTrips(from data: Data) throws -> [Trip] {
        let decoded = try JSONDecoder().decode(RaspSearchDTO.self, from: data)
        return (decoded.segments ?? []).compactMap(Trip.init)
    }
}
