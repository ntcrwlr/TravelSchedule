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

    static func fetchLogoURL(code: String, apikey: String) async -> URL? {
        var components = URLComponents(string: "https://api.rasp.yandex.net/v3.0/carrier/")
        components?.queryItems = [
            URLQueryItem(name: "apikey", value: apikey),
            URLQueryItem(name: "code", value: code),
            URLQueryItem(name: "format", value: "json")
        ]
        guard let url = components?.url else { return nil }

        guard let (data, response) = try? await URLSession.shared.data(from: url),
              (response as? HTTPURLResponse)?.statusCode == HTTPStatusCode.ok,
              let envelope = try? JSONDecoder().decode(RaspCarrierEnvelope.self, from: data)
        else {
            return nil
        }

        let carrier = envelope.carrier
        return carrier?.rasterLogoPath?.httpsURL
    }
}
