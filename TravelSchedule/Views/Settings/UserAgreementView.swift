import SwiftUI

struct UserAgreementView: View {
    @State private var blocks: [IdentifiedAgreementBlock] = []
    @State private var isLoading = true

    var body: some View {
        ZStack {
            ScrollView {
                LazyVStack(alignment: .leading, spacing: 16) {
                    ForEach(blocks) { item in
                        blockView(item.block)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 16)
            }
            .opacity(isLoading ? 0 : 1)

            ProgressView()
                .opacity(isLoading ? 1 : 0)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(AppColor.background)
        .appErrorOverlay()
        .navigationTitle(AppStrings.userAgreement)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar(.hidden, for: .tabBar)
        .toolbar(.visible, for: .navigationBar)
        .toolbarBackground(AppColor.background, for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .tint(AppColor.text)
        .task {
            await loadAgreement()
        }
    }

    @ViewBuilder
    private func blockView(_ block: AgreementBlock) -> some View {
        switch block {
        case .title(let text):
            Text(text)
                .font(AppTypography.screenTitle)
                .foregroundStyle(AppColor.text)
                .fixedSize(horizontal: false, vertical: true)
                .padding(.bottom, 8)

        case .section(let text):
            Text(text)
                .font(AppTypography.sectionTitle)
                .foregroundStyle(AppColor.text)
                .fixedSize(horizontal: false, vertical: true)
                .padding(.top, 8)

        case .paragraph(let text):
            Text(styled(text))
                .font(AppTypography.body)
                .foregroundStyle(AppColor.text)
                .tint(AppColor.blue)
                .fixedSize(horizontal: false, vertical: true)
                .textSelection(.enabled)

        case .bullet(let text):
            HStack(alignment: .top, spacing: 8) {
                Text("•")
                    .font(AppTypography.body)
                    .foregroundStyle(AppColor.text)
                Text(styled(text))
                    .font(AppTypography.body)
                    .foregroundStyle(AppColor.text)
                    .tint(AppColor.blue)
                    .fixedSize(horizontal: false, vertical: true)
                    .textSelection(.enabled)
            }
        }
    }

    private func styled(_ text: AttributedString) -> AttributedString {
        var result = text
        result.foregroundColor = Color(uiColor: .appText)

        for run in result.runs {
            let range = run.range
            if run.inlinePresentationIntent?.contains(.stronglyEmphasized) == true {
                result[range].font = AppTypography.bodyBold
            }
            if run.link != nil {
                result[range].foregroundColor = AppColor.blue
            }
        }
        return result
    }

    private func loadAgreement() async {
        isLoading = true
        AppErrorCenter.shared.report(nil)

        let markdown = await UserAgreementLoader.loadMarkdown()
        guard !markdown.isEmpty else {
            isLoading = false
            AppErrorCenter.shared.report(.server)
            return
        }

        blocks = AgreementMarkdownParser.blocks(from: markdown)
        isLoading = false
    }
}

#Preview {
    NavigationStack {
        UserAgreementView()
    }
}
