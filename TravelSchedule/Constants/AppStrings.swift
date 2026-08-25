import Foundation

enum AppStrings {
    static let from = "Откуда"
    static let to = "Куда"
    static let find = "Найти"
    static let swapStations = "Поменять местами"
    static let settings = "Настройки"
    static let darkTheme = "Темная тема"
    static let userAgreement = "Пользовательское соглашение"
    static let userAgreementURL = "https://yandex.ru/legal/practicum_offer/ru/"
    static let apiCredit = "Приложение использует API «Яндекс.Расписания»"
    static let appVersion = "Версия 1.0 (beta)"
    static let searchPlaceholder = "Введите запрос"

    static let citySearchTitle = "Выбор города"
    static let cityNotFound = "Город не найден"
    static let stationSearchTitle = "Выбор станции"
    static let stationNotFound = "Станция не найдена"

    static let noVariants = "Вариантов нет"
    static let refineTime = "Уточнить время"
    static let carrierInfo = "Информация о перевозчике"
    static let carrierFallback = "Перевозчик"
    static let email = "E-mail"
    static let phone = "Телефон"
    static let website = "Сайт"

    static let departureTime = "Время отправления"
    static let showTransfers = "Показывать варианты с пересадками"
    static let yes = "Да"
    static let no = "Нет"
    static let apply = "Применить"

    static let noInternet = "Нет интернета"
    static let serverError = "Ошибка сервера"

    static let morningSlot = "Утро 06:00 – 12:00"
    static let daySlot = "День 12:00 – 18:00"
    static let eveningSlot = "Вечер 18:00 – 00:00"
    static let nightSlot = "Ночь 00:00 – 06:00"

    static let transferPrefix = "С пересадкой в "
    static let transferFallback = "С пересадкой"

    static let storyTitle = "Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text"
    static let storyPreviewText = "Text\nText Text\nText Text"
    static let storyText = "Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text"

    static func routeTitle(from: String, to: String) -> String {
        "\(from) → \(to)"
    }
}
