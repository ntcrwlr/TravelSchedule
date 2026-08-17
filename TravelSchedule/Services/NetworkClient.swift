import Foundation
import OpenAPIRuntime
import OpenAPIURLSession

enum NetworkClient {
    static func make() throws -> Client {
        Client(
            serverURL: try Servers.Server1.url(),
            transport: URLSessionTransport()
        )
    }
}
