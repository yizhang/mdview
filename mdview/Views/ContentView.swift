import SwiftUI
import MarkdownUI
import AppKit

private struct WindowAccessor: NSViewRepresentable {
    let onWindow: (NSWindow) -> Void

    func makeNSView(context: Context) -> NSView {
        let view = NSView()
        DispatchQueue.main.async {
            if let window = view.window {
                onWindow(window)
            }
        }
        return view
    }
    func updateNSView(_ nsView: NSView, context: Context) {}
}

struct DocumentEditorView: View {
    @ObservedObject var document: MarkdownDocument
    @State private var hasRestoredWindowSize = false

    var body: some View {
        ContentView(
            text: $document.text,
            initialTab: document.text.isEmpty ? .editor : .preview
        )
        .background(
            WindowAccessor { window in
                if !hasRestoredWindowSize {
                    hasRestoredWindowSize = true
                    if let sizeData = UserDefaults.standard.data(forKey: "LastWindowSize"),
                       let size = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(sizeData) as? NSSize {
                        window.setContentSize(size)
                    }
                }
                NotificationCenter.default.addObserver(forName: NSWindow.didEndLiveResizeNotification, object: window, queue: .main) { _ in
                    let size = window.frame.size
                    if let data = try? NSKeyedArchiver.archivedData(withRootObject: size, requiringSecureCoding: false) {
                        UserDefaults.standard.set(data, forKey: "LastWindowSize")
                    }
                }
            }
        )
    }
}

struct ContentView: View {
    @Binding var text: String
    let initialTab: Tab
    @State private var selectedTab: Tab
    @State private var theme: MarkdownTheme = .gitHub
    @State private var editorFontSize: CGFloat = 14

    enum Tab: String, CaseIterable {
        case editor = "Editor"
        case preview = "Preview"
        case split = "Split"
    }

    init(text: Binding<String>, initialTab: Tab) {
        self._text = text
        self.initialTab = initialTab
        self._selectedTab = State(initialValue: initialTab)
    }

    var body: some View {
        VStack(spacing: 0) {
            toolbar
            Divider()
            editorArea
        }
        .frame(minWidth: 700, minHeight: 500)
    }

    private var toolbar: some View {
        HStack(spacing: 12) {
            Picker("View", selection: $selectedTab) {
                ForEach(Tab.allCases, id: \.self) { tab in
                    Text(tab.rawValue).tag(tab)
                }
            }
            .pickerStyle(.segmented)
            .labelsHidden()

            Divider()
                .frame(height: 20)

            Picker("Theme", selection: $theme) {
                Text("GitHub").tag(MarkdownTheme.gitHub)
                Text("Basic").tag(MarkdownTheme.basic)
                Text("DocC").tag(MarkdownTheme.docC)
            }
            .frame(width: 120)

            Divider()
                .frame(height: 20)

            HStack(spacing: 4) {
                Button {
                    editorFontSize = max(10, editorFontSize - 1)
                } label: {
                    Image(systemName: "minus")
                }
                .buttonStyle(.borderless)

                Text("\(Int(editorFontSize))pt")
                    .font(.caption)
                    .monospacedDigit()
                    .frame(width: 36)

                Button {
                    editorFontSize = min(32, editorFontSize + 1)
                } label: {
                    Image(systemName: "plus")
                }
                .buttonStyle(.borderless)
            }

            Spacer()

            Text("\(text.count) characters")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 6)
    }

    @ViewBuilder
    private var editorArea: some View {
        switch selectedTab {
        case .editor:
            MarkdownEditor(text: $text, fontSize: $editorFontSize)
        case .preview:
            MarkdownPreview(text: text, theme: theme)
        case .split:
            HSplitView {
                MarkdownEditor(text: $text, fontSize: $editorFontSize)
                    .frame(minWidth: 300)
                MarkdownPreview(text: text, theme: theme)
                    .frame(minWidth: 300)
            }
        }
    }
}

enum MarkdownTheme {
    case gitHub
    case basic
    case docC

    var theme: MarkdownUI.Theme {
        switch self {
        case .gitHub: return .gitHub
        case .basic: return .basic
        case .docC: return .docC
        }
    }
}
