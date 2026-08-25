//
//  TravelScheduleApp.swift
//  TravelSchedule
//
//  Created by Сергей Бушков on 09.08.2026.
//

import SwiftUI
import UIKit

@main
struct TravelScheduleApp: App {
    init() {
        _ = AppErrorCenter.shared
        AppAppearance.configure()
    }

    var body: some Scene {
        WindowGroup {
            RootView()
        }
    }
}

struct RootView: View {
    @State private var isSplashVisible = true
    @AppStorage(AppThemeStorage.isDarkThemeKey) private var isDarkTheme = false

    var body: some View {
        ZStack {
            MainTabView()
            SplashView()
                .opacity(isSplashVisible ? 1 : 0)
                .allowsHitTesting(isSplashVisible)
        }
        .preferredColorScheme(isDarkTheme ? .dark : .light)
        .onAppear {
            applyInterfaceStyle()
        }
        .onChange(of: isDarkTheme) { _, _ in
            applyInterfaceStyle()
        }
        .task {
            try? await Task.sleep(for: .seconds(2))
            withAnimation(.easeOut(duration: 0.25)) {
                isSplashVisible = false
            }
        }
    }

    private func applyInterfaceStyle() {
        let style: UIUserInterfaceStyle = isDarkTheme ? .dark : .light
        UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap(\.windows)
            .forEach { window in
                window.overrideUserInterfaceStyle = style
            }
    }
}
