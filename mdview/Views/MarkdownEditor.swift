import SwiftUI

struct MarkdownEditor: View {
    @Binding var text: String
    @Binding var fontSize: CGFloat

    var body: some View {
        TextEditor(text: $text)
            .font(.system(size: fontSize, design: .monospaced))
            .scrollContentBackground(.hidden)
            .background(Color(nsColor: .textBackgroundColor))
            .padding(8)
    }
}
