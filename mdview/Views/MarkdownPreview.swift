import SwiftUI
import MarkdownUI

struct MarkdownPreview: View {
    let text: String
    let theme: MarkdownTheme

    var body: some View {
        ScrollView {
            Markdown(text)
                .markdownTheme(theme.theme)
                .markdownTextStyle {
                    FontSize(.em(1))
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .background(Color(nsColor: .controlBackgroundColor))
    }
}
