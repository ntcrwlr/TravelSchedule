import Foundation

enum AppLoadError {
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
            return "Нет интернета"
        case .server:
            return "Ошибка сервера"
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
