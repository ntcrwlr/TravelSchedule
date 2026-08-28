import Foundation

enum UserAgreementLoader {
    static let remoteMarkdownURL = URL(
        string: "https://yandex.ru/legal/practicum_offer/ru/index.md"
    )!

    static func loadBundledMarkdown() -> String? {
        guard let url = Bundle.main.url(forResource: "UserAgreement", withExtension: "md") else {
            return nil
        }
        return try? String(contentsOf: url, encoding: .utf8)
    }

    static func sanitize(_ raw: String) -> String {
        var text = raw

        if text.hasPrefix("---") {
            let remainder = text.dropFirst(3)
            if let end = remainder.range(of: "\n---") {
                text = String(remainder[end.upperBound...]).trimmingCharacters(in: .whitespacesAndNewlines)
            }
        }

        let lines = text.components(separatedBy: .newlines)
        var result: [String] = []
        var skippingQuote = false

        for line in lines {
            if line.contains("Documentation Index:") {
                skippingQuote = true
                continue
            }
            if skippingQuote {
                if line.hasPrefix(">") || line.trimmingCharacters(in: .whitespaces).isEmpty {
                    continue
                }
                skippingQuote = false
            }
            result.append(line)
        }

        return result
            .joined(separator: "\n")
            .replacingOccurrences(of: "\\.", with: ".")
            .trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
