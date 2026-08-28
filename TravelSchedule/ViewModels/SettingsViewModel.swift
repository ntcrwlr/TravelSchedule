import Combine
import Foundation

@MainActor
final class SettingsViewModel: ObservableObject {
    @Published var isDarkTheme: Bool {
        didSet {
            guard oldValue != isDarkTheme else { return }
            UserDefaults.standard.set(isDarkTheme, forKey: AppThemeStorage.isDarkThemeKey)
        }
    }

    @Published var isAgreementPresented = false

    var apiCreditText: String { AppStrings.apiCredit }
    var appVersionText: String { AppStrings.appVersion }

    private var cancellables = Set<AnyCancellable>()

    init() {
        isDarkTheme = UserDefaults.standard.bool(forKey: AppThemeStorage.isDarkThemeKey)
        subscribeToExternalThemeChanges()
    }

    func presentUserAgreement() {
        isAgreementPresented = true
    }

    private func subscribeToExternalThemeChanges() {
        NotificationCenter.default.publisher(for: UserDefaults.didChangeNotification)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let self else { return }
                let stored = UserDefaults.standard.bool(forKey: AppThemeStorage.isDarkThemeKey)
                if stored != isDarkTheme {
                    isDarkTheme = stored
                }
            }
            .store(in: &cancellables)
    }
}
