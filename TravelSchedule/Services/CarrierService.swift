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
}
