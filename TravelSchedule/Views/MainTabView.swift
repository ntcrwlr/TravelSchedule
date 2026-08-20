import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            ScheduleSearchView()
            .tabItem {
                Image(systemName: "arrow.up.message.fill")
            }

            NavigationStack {
                SettingsView()
            }
            .tabItem {
                Image(systemName: "gearshape.fill")
            }
        }
        .tint(AppColor.text)
        .toolbarBackground(AppColor.background, for: .tabBar)
        .toolbarBackground(.visible, for: .tabBar)
    }
}

#Preview {
    MainTabView()
}

#Preview("Тёмная тема") {
    MainTabView()
        .preferredColorScheme(.dark)
}
