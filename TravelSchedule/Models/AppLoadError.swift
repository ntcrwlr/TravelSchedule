import Foundation

enum AppLoadError: Sendable {
    case noInternet
    case server

    var imageName: String {
        switch self {
        case .noInternet:
            return "No Internet"
        case .server:
            return "Server Error"
        }
    }

    var title: String {
        switch self {
        case .noInternet:
            return AppStrings.noInternet
        case .server:
            return AppStrings.serverError
        }
    }

    init(error: Error) {
        guard let urlError = error as? URLError else {
            self = .server
            return
        }

        switch urlError.code {
        case .notConnectedToInternet, .networkConnectionLost, .dataNotAllowed, .internationalRoamingOff:
            self = .noInternet
        default:
            self = .server
        }
    }
}
