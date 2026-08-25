import SwiftUI

struct PlainListButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .opacity(configuration.isPressed ? 0.7 : 1)
    }
}

extension ButtonStyle where Self == PlainListButtonStyle {
    static var plainList: PlainListButtonStyle { PlainListButtonStyle() }
}
