import Foundation
import OpenAPIRuntime
import OpenAPIURLSession

typealias CarrierInfo = Components.Schemas.CarrierResponse

protocol CarrierServiceProtocol {
    func getCarrier(code: String) async throws -> CarrierInfo
}

final class CarrierService: CarrierServiceProtocol {
    private let client: Client
    private let apikey: String

    init(client: Client, apikey: String) {
        self.client = client
        self.apikey = apikey
    }

    func getCarrier(code: String) async throws -> CarrierInfo {
        let response = try await client.getCarrier(query: .init(
            apikey: apikey,
            code: code
        ))
        return try response.ok.body.json
    }

    func fetchDetails(code: String) async throws -> CarrierDetails {
        var components = URLComponents(string: "https://api.rasp.yandex.net/v3.0/carrier/")
        components?.queryItems = [
            URLQueryItem(name: "apikey", value: apikey),
            URLQueryItem(name: "code", value: code),
            URLQueryItem(name: "format", value: "json")
        ]
        guard let url = components?.url else {
            throw URLError(.badURL)
        }

        let (data, response) = try await URLSession.shared.data(from: url)
        let statusCode = (response as? HTTPURLResponse)?.statusCode ?? 0

        guard statusCode == HTTPStatusCode.ok else {
            throw URLError(.badServerResponse)
        }

        let envelope = try JSONDecoder().decode(RaspCarrierEnvelope.self, from: data)
        guard let details = envelope.carrier?.details else {
            throw URLError(.cannotDecodeContentData)
        }
        return details
    }
}
