import SwiftUI

struct SettingsView: View {
    @StateObject private var viewModel = SettingsViewModel()

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text(AppStrings.darkTheme)
                    .font(AppTypography.body)
                    .foregroundStyle(AppColor.text)
                Spacer()
                Toggle("", isOn: $viewModel.isDarkTheme)
                    .labelsHidden()
                    .tint(AppColor.blue)
            }
            .padding(.horizontal, 16)
            .frame(height: 60)

            Button {
                viewModel.presentUserAgreement()
            } label: {
                SelectionRow(title: AppStrings.userAgreement)
            }
            .buttonStyle(.plain)

            Spacer()

            VStack(spacing: 4) {
                Text(viewModel.apiCreditText)
                Text(viewModel.appVersionText)
            }
            .font(AppTypography.caption)
            .foregroundStyle(AppColor.text)
            .multilineTextAlignment(.center)
            .padding(.horizontal, 16)
            .padding(.bottom, 24)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(AppColor.background)
        .appErrorOverlay()
        .toolbar(.hidden, for: .navigationBar)
        .toolbar(viewModel.isAgreementPresented ? .hidden : .visible, for: .tabBar)
        .navigationDestination(isPresented: $viewModel.isAgreementPresented) {
            UserAgreementView()
        }
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
