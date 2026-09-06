import Foundation

enum ApiKey {
    private static let infoPlistKey = "YandexRaspAPIKey"

    static var yandexRasp: String {
        guard
            let key = Bundle.main.object(forInfoDictionaryKey: infoPlistKey) as? String,
            !key.isEmpty,
            !key.hasPrefix("$(")
        else {
            assertionFailure(
                """
                Missing \(infoPlistKey) in Info.plist.
                Copy Config/Secrets.xcconfig.example to Config/Secrets.xcconfig \
                and set YANDEX_RASP_API_KEY.
                """
            )
            return ""
        }
        return key
    }
}
