import SwiftUI

@main
struct MDViewApp: App {
    var body: some Scene {
        DocumentGroup(newDocument: { MarkdownDocument() }) { file in
            DocumentEditorView(document: file.document)
        }
        .commands {
            CommandGroup(replacing: .newItem) {
                Button("New") {
                    NSDocumentController.shared.newDocument(nil)
                }
                .keyboardShortcut("n")
            }
            CommandGroup(replacing: .importExport) {
                Button("Open...") {
                    NSDocumentController.shared.openDocument(nil)
                }
                .keyboardShortcut("o")
            }
            CommandGroup(replacing: .saveItem) {
                Button("Save") {
                    NSApp.sendAction(#selector(NSDocument.save(_:)), to: nil, from: nil)
                }
                .keyboardShortcut("s")

                Button("Save As...") {
                    NSApp.sendAction(#selector(NSDocument.saveAs(_:)), to: nil, from: nil)
                }
                .keyboardShortcut("s", modifiers: [.command, .shift])

                Divider()

                Button("Revert to Saved") {
                    NSApp.sendAction(#selector(NSDocument.revertToSaved(_:)), to: nil, from: nil)
                }
            }
            CommandGroup(replacing: .printItem) {
                Button("Print...") {
                    NSApp.sendAction(#selector(NSDocument.printDocument(_:)), to: nil, from: nil)
                }
                .keyboardShortcut("p")
            }
        }
    }
}
