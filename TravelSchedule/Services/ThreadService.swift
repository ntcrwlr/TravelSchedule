import Foundation
import OpenAPIRuntime
import OpenAPIURLSession

typealias ThreadStations = Components.Schemas.ThreadResponse

protocol ThreadServiceProtocol {
    func getThread(uid: String) async throws -> ThreadStations
}

final class ThreadService: ThreadServiceProtocol {
    private let client: Client
    private let apikey: String

    init(client: Client, apikey: String) {
        self.client = client
        self.apikey = apikey
    }

    func getThread(uid: String) async throws -> ThreadStations {
        let response = try await client.getThread(query: .init(
            apikey: apikey,
            uid: uid
        ))
        return try response.ok.body.json
    }
}
