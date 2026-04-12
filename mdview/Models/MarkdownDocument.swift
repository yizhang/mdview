import SwiftUI
import UniformTypeIdentifiers
import Combine

extension UTType {
    static let markdown = UTType(exportedAs: "net.daringfireball.markdown")
}

final class MarkdownDocument: ReferenceFileDocument, ObservableObject {
    typealias Snapshot = Data

    static var readableContentTypes: [UTType] { [.markdown, .plainText] }
    static var writableContentTypes: [UTType] { [.markdown] }

    @Published var text: String

    init(initialText: String = "") {
        self.text = initialText
    }

    required init(configuration: ReadConfiguration) throws {
        guard let data = configuration.file.regularFileContents,
              let string = String(data: data, encoding: .utf8)
        else {
            throw CocoaError(.fileReadCorruptFile)
        }
        self.text = string
    }

    func snapshot(contentType: UTType) throws -> Data {
        text.data(using: .utf8) ?? Data()
    }

    func fileWrapper(snapshot: Data, configuration: WriteConfiguration) throws -> FileWrapper {
        FileWrapper(regularFileWithContents: snapshot)
    }
}
