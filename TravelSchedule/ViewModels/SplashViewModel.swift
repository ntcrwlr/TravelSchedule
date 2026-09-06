import Combine
import Foundation
import SwiftUI

@MainActor
final class SplashViewModel: ObservableObject {
    @Published var isVisible = true

    func runSplashSequence() async {
        try? await Task.sleep(for: .seconds(2))
        withAnimation(.easeOut(duration: 0.25)) {
            isVisible = false
        }
    }
}
