import SwiftUI

struct SettingsView: View {
    @AppStorage(AppThemeStorage.isDarkThemeKey) private var isDarkTheme = false
    @State private var isAgreementPresented = false

    var body: some View {
        VStack(spacing: 0) {
            darkThemeRow
            userAgreementRow
            Spacer()
            footer
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(AppColor.background)
        .appErrorOverlay()
        .toolbar(.hidden, for: .navigationBar)
        .toolbar(isAgreementPresented ? .hidden : .visible, for: .tabBar)
        .navigationDestination(isPresented: $isAgreementPresented) {
            UserAgreementView()
        }
    }

    private var darkThemeRow: some View {
        HStack {
            Text(AppStrings.darkTheme)
                .font(AppTypography.body)
                .foregroundStyle(AppColor.text)
            Spacer()
            Toggle("", isOn: $isDarkTheme)
                .labelsHidden()
                .tint(AppColor.blue)
        }
        .padding(.horizontal, 16)
        .frame(height: 60)
    }

    private var userAgreementRow: some View {
        Button {
            isAgreementPresented = true
        } label: {
            SelectionRow(title: AppStrings.userAgreement)
        }
        .buttonStyle(.plain)
    }

    private var footer: some View {
        VStack(spacing: 4) {
            Text(AppStrings.apiCredit)
            Text(AppStrings.appVersion)
        }
        .font(AppTypography.caption)
        .foregroundStyle(AppColor.text)
        .multilineTextAlignment(.center)
        .padding(.horizontal, 16)
        .padding(.bottom, 24)
    }
}

#Preview {
    NavigationStack {
        SettingsView()
    }
}

#Preview("Тёмная тема") {
    NavigationStack {
        SettingsView()
    }
    .preferredColorScheme(.dark)
}
