import SwiftUI

struct SearchListScreen<Content: View>: View {
    let title: String
    let emptyMessage: String
    let isEmpty: Bool
    @Binding var query: String
    @ViewBuilder let content: () -> Content

    var body: some View {
        VStack(spacing: 0) {
            SearchQueryField(text: $query)

            ZStack {
                ScrollView {
                    LazyVStack(spacing: 0) {
                        content()
                    }
                }
                .scrollDismissesKeyboard(.immediately)
                .hiddenWhen(isEmpty)
                .allowsHitTesting(!isEmpty)

                Text(emptyMessage)
                    .font(AppTypography.screenTitle)
                    .foregroundStyle(AppColor.text)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 16)
                    .hiddenWhen(!isEmpty)
                    .allowsHitTesting(false)
            }
        }
        .searchListScreenStyle(title: title)
    }
}

private struct SearchListScreenStyle: ViewModifier {
    let title: String

    func body(content: Content) -> some View {
        content
            .background(AppColor.background)
            .appErrorOverlay()
            .navigationTitle(title)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar(.visible, for: .navigationBar)
            .toolbar(.hidden, for: .tabBar)
            .toolbarBackground(AppColor.background, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .tint(AppColor.text)
    }
}

extension View {
    func searchListScreenStyle(title: String) -> some View {
        modifier(SearchListScreenStyle(title: title))
    }
}
