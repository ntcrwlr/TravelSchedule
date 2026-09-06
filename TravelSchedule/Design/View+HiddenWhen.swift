import SwiftUI

extension View {
    func hiddenWhen(_ condition: Bool) -> some View {
        opacity(condition ? 0 : 1)
    }
}
