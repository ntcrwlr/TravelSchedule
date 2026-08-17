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

    var body: some View {
        ZStack {
            MainTabView()
            SplashView()
                .opacity(isSplashVisible ? 1 : 0)
                .allowsHitTesting(isSplashVisible)
        }
        .task {
            try? await Task.sleep(for: .seconds(2))
            withAnimation(.easeOut(duration: 0.25)) {
                isSplashVisible = false
            }
        }
    }
}
