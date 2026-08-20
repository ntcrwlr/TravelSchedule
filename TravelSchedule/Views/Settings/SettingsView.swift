import SwiftUI

struct SettingsView: View {
    var body: some View {
        Text("Настройки")
            .font(.system(size: 24, weight: .bold))
            .foregroundStyle(AppColor.text)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(AppColor.background)
            .appErrorOverlay()
    }
}

#Preview {
    SettingsView()
}
