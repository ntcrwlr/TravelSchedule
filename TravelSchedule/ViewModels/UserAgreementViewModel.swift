import Combine
import Foundation

@MainActor
final class UserAgreementViewModel: ObservableObject {
    @Published private(set) var blocks: [IdentifiedAgreementBlock] = []
    @Published private(set) var isLoading = true

    func load() async {
        isLoading = true
        AppErrorCenter.shared.report(nil)

        let markdown = await NetworkClient.shared.loadUserAgreementMarkdown()
        guard !markdown.isEmpty else {
            isLoading = false
            AppErrorCenter.shared.report(.server)
            return
        }

        blocks = AgreementMarkdownParser.blocks(from: markdown)
        isLoading = false
    }
}
