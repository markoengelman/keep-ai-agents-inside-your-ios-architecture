import Foundation
import Testing

struct ArchitectureTests {
    /* The only modules each layer may import */
    static let allowedImports: [String: Set<String>] = [
        "FavouritesDomain": ["Foundation"],
        "FavouritesData": ["Foundation", "FavouritesDomain"],
        "FavouritesPresentation": ["Foundation", "Observation", "FavouritesDomain"],
        "FavouritesUI": ["Foundation", "SwiftUI", "FavouritesPresentation"],
    ]

    @Test(arguments: allowedImports.keys.sorted())
    func layerRespectsItsBoundaries(_ layer: String) throws {
        let files = try swiftFiles(in: "Sources/\(layer)")
        try #require(!files.isEmpty, "Found no Swift files in Sources/\(layer)")

        for file in files {
            let violations = try importedModules(in: file).subtracting(Self.allowedImports[layer, default: []])
            #expect(violations.isEmpty, "\(layer)/\(file.lastPathComponent) imports \(violations.sorted())")
        }
    }

    private func swiftFiles(in directory: String) throws -> [URL] {
        let root = URL(filePath: #filePath)
            .deletingLastPathComponent()
            .deletingLastPathComponent()
            .deletingLastPathComponent()
            .appending(path: directory)

        let files = FileManager.default.enumerator(at: root, includingPropertiesForKeys: nil)
        return (files?.allObjects as? [URL] ?? []).filter { $0.pathExtension == "swift" }
    }

    private func importedModules(in file: URL) throws -> Set<String> {
        let source = try String(contentsOf: file, encoding: .utf8)
        /* Matches `import X`, `@preconcurrency import X`, `public import X` and `import struct X.Y` */
        let anyImport = #/^[ \t]*(?:@\w+[ \t]+)*(?:\w+[ \t]+)?import[ \t]+(?:\w+[ \t]+)?(\w+)/#
        return Set(source.matches(of: anyImport.anchorsMatchLineEndings()).map { String($0.1) })
    }
}
