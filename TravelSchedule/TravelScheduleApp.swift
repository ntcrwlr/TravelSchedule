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
    @StateObject private var splashViewModel = SplashViewModel()
    @AppStorage(AppThemeStorage.isDarkThemeKey) private var isDarkTheme = false

    var body: some View {
        ZStack {
            MainTabView()
            SplashView()
                .opacity(splashViewModel.isVisible ? 1 : 0)
                .allowsHitTesting(splashViewModel.isVisible)
        }
        .preferredColorScheme(isDarkTheme ? .dark : .light)
        .onAppear {
            applyInterfaceStyle()
        }
        .onChange(of: isDarkTheme) { _, _ in
            applyInterfaceStyle()
        }
        .task {
            await splashViewModel.runSplashSequence()
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
