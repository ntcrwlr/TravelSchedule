import Combine
import SwiftUI

@MainActor
final class SettingsViewModel: ObservableObject {
    @AppStorage(AppThemeStorage.isDarkThemeKey) var isDarkTheme = false
    @Published var isAgreementPresented = false

    var apiCreditText: String { AppStrings.apiCredit }
    var appVersionText: String { AppStrings.appVersion }

    func presentUserAgreement() {
        isAgreementPresented = true
    }
}
