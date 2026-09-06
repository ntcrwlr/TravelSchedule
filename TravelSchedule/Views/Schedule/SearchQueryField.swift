import SwiftUI

struct SearchQueryField: View {
    @Binding var text: String
    @FocusState private var isFocused: Bool

    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: AppSymbol.search)
                .foregroundStyle(AppColor.gray)

            TextField(AppStrings.searchPlaceholder, text: $text)
                .foregroundStyle(AppColor.text)
                .focused($isFocused)
                .tint(AppColor.text)

            Button {
                text = ""
            } label: {
                Image(systemName: AppSymbol.clearSearch)
                    .foregroundStyle(AppColor.gray)
            }
            .buttonStyle(.plain)
            .hiddenWhen(!isFocused && text.isEmpty)
            .disabled(text.isEmpty)
        }
        .padding(.horizontal, 12)
        .frame(height: 36)
        .background(AppColor.searchBar)
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
    }
}

struct SelectionRow: View {
    let title: String

    var body: some View {
        HStack {
            Text(title)
                .font(AppTypography.body)
                .foregroundStyle(AppColor.text)
                .lineLimit(1)
            Spacer()
            Image(systemName: AppSymbol.chevronRight)
                .font(AppTypography.chevron)
                .foregroundStyle(AppColor.gray)
        }
        .padding(.horizontal, 16)
        .frame(height: 60)
        .contentShape(Rectangle())
    }
}
