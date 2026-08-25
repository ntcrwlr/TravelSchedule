import Foundation

enum AgreementBlock: Equatable {
    case title(String)
    case section(String)
    case paragraph(AttributedString)
    case bullet(AttributedString)
}

struct IdentifiedAgreementBlock: Identifiable, Equatable {
    let id: Int
    let block: AgreementBlock
}

enum AgreementMarkdownParser {
    static func blocks(from markdown: String) -> [IdentifiedAgreementBlock] {
        let lines = markdown
            .replacingOccurrences(of: "\r\n", with: "\n")
            .components(separatedBy: "\n")

        var blocks: [AgreementBlock] = []
        var paragraphLines: [String] = []

        func flushParagraph() {
            let joined = paragraphLines
                .map { $0.trimmingCharacters(in: .whitespaces) }
                .filter { !$0.isEmpty }
                .joined(separator: " ")
            paragraphLines.removeAll()

            guard !joined.isEmpty else { return }

            if joined.hasPrefix("- ") || joined.hasPrefix("* ") {
                let content = String(joined.dropFirst(2))
                blocks.append(.bullet(inlineAttributed(from: content)))
            } else {
                blocks.append(.paragraph(inlineAttributed(from: joined)))
            }
        }

        for rawLine in lines {
            let line = rawLine.trimmingCharacters(in: .whitespaces)

            if line.isEmpty {
                flushParagraph()
                continue
            }

            if line.hasPrefix("# ") {
                flushParagraph()
                blocks.append(.title(String(line.dropFirst(2))))
                continue
            }

            if line.hasPrefix("## ") {
                flushParagraph()
                blocks.append(.section(String(line.dropFirst(3))))
                continue
            }

            if line.hasPrefix("### ") {
                flushParagraph()
                blocks.append(.section(String(line.dropFirst(4))))
                continue
            }

            if line.hasPrefix("- ") || line.hasPrefix("* ") {
                flushParagraph()
                blocks.append(.bullet(inlineAttributed(from: String(line.dropFirst(2)))))
                continue
            }

            paragraphLines.append(line)
        }

        flushParagraph()
        return blocks.enumerated().map { IdentifiedAgreementBlock(id: $0.offset, block: $0.element) }
    }

    private static func inlineAttributed(from text: String) -> AttributedString {
        let normalized = text.replacingOccurrences(
            of: #"<((?:https?|mailto):[^>\s]+)>"#,
            with: "$1",
            options: .regularExpression
        )

        if let attributed = try? AttributedString(
            markdown: normalized,
            options: AttributedString.MarkdownParsingOptions(
                interpretedSyntax: .inlineOnlyPreservingWhitespace,
                failurePolicy: .returnPartiallyParsedIfPossible
            )
        ) {
            return attributed
        }

        return AttributedString(stripMarkdown(normalized))
    }

    private static func stripMarkdown(_ text: String) -> String {
        text
            .replacingOccurrences(of: "**", with: "")
            .replacingOccurrences(of: #"\[(.*?)\]\((.*?)\)"#, with: "$1", options: .regularExpression)
    }
}
