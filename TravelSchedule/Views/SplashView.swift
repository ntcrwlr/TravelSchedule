//
//  SplashView.swift
//  TravelSchedule
//
//  Created by Сергей Бушков on 09.08.2026.
//

import SwiftUI

struct SplashView: View {
    var body: some View {
        ZStack {
            Color.black
            Image("Splash Screen")
                .resizable()
                .scaledToFill()
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
        }
        .ignoresSafeArea()
        .statusBarHidden()
    }
}

#Preview {
    SplashView()
}
