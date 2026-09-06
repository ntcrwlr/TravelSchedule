import SwiftUI

struct AppErrorOverlay: ViewModifier {
    @State private var errorCenter = AppErrorCenter.shared

    func body(content: Content) -> some View {
        content.overlay {
            ErrorStateView(error: errorCenter.error)
        }
    }
}

extension View {
    func appErrorOverlay() -> some View {
        modifier(AppErrorOverlay())
    }
}
