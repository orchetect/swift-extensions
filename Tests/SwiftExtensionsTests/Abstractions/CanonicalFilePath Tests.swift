//
//  CanonicalFilePath Tests.swift
//  swift-extensions • https://github.com/orchetect/swift-extensions
//  © 2026 Steffan Andrews • Licensed under MIT License
//

#if os(macOS) && canImport(Foundation) && canImport(System)

import Foundation
import SwiftExtensions
import System
import Testing

@Suite
struct Abstractions_CanonicalFilePath_Tests {
    // MARK: - Inits: String

    @available(macOS 12.0, *)
    @Test
    func init_canonicalizing_string_knownPathA() throws {
        let cpath = try CanonicalFilePath(canonicalizing: "/users")
        #expect(cpath.isCanonical)
        #expect(cpath.string == "/Users")
    }

    @available(macOS 12.0, *)
    @Test
    func init_canonicalizing_string_knownPathB() throws {
        let tempDir = URL.temporaryDirectory.path
        #expect(tempDir.starts(with: "/var/"))

        // path canonicalization adds `/private` to start of temporary directory path.
        let cpath = try CanonicalFilePath(canonicalizing: tempDir)
        #expect(cpath.isCanonical)
        #expect(cpath.string.starts(with: "/private/var/"))
    }

    @available(macOS 12.0, *)
    @Test
    func init_canonicalizing_string_unknownPath() throws {
        let pathString = "/This/path/Does/not/Exist/\(UUID().uuidString)"
        #expect(throws: (any Error).self) { try CanonicalFilePath(canonicalizing: pathString) }
    }

    @available(macOS 12.0, *)
    @Test
    func init_canonicalizingIfPossible_string_knownPath() {
        let cpath = CanonicalFilePath(canonicalizingIfPossible: "/users")
        #expect(cpath.isCanonical)
        #expect(cpath.string == "/Users")
    }

    @available(macOS 12.0, *)
    @Test
    func init_canonicalizingIfPossible_string_unknownPath() {
        let pathString = "/This/path/Does/not/Exist/\(UUID().uuidString)"
        let cpath = CanonicalFilePath(canonicalizingIfPossible: pathString)
        #expect(!cpath.isCanonical)
        #expect(cpath.string == pathString)
    }

    // MARK: - Inits: URL

    @available(macOS 12.0, *)
    @Test
    func init_canonicalizing_url_knownPathA() throws {
        let cpath = try CanonicalFilePath(canonicalizing: URL(fileURLWithPath: "/users"))
        #expect(cpath.isCanonical)
        #expect(cpath.string == "/Users")
    }

    @available(macOS 12.0, *)
    @Test
    func init_canonicalizing_url_knownPathB() throws {
        let tempDir = URL.temporaryDirectory
        #expect(tempDir.pathComponents.starts(with: ["/", "var"]))

        // path canonicalization adds `/private` to start of temporary directory path.
        let cpath = try CanonicalFilePath(canonicalizing: tempDir)
        #expect(cpath.isCanonical)
        #expect(cpath.string.starts(with: "/private/var"))
    }

    @available(macOS 12.0, *)
    @Test
    func init_canonicalizing_url_unknownPath() throws {
        let pathURL = URL(fileURLWithPath: "/This/path/Does/not/Exist/\(UUID().uuidString)")
        #expect(throws: (any Error).self) { try CanonicalFilePath(canonicalizing: pathURL) }
    }

    @available(macOS 12.0, *)
    @Test
    func init_canonicalizingIfPossible_url_knownPath() {
        let cpath = CanonicalFilePath(canonicalizingIfPossible: URL(fileURLWithPath: "/users"))
        #expect(cpath.isCanonical)
        #expect(cpath.string == "/Users")
    }

    @available(macOS 12.0, *)
    @Test
    func init_canonicalizingIfPossible_url_unknownPath() {
        let pathString = "/This/path/Does/not/Exist/\(UUID().uuidString)"
        let pathURL = URL(fileURLWithPath: pathString)
        let cpath = CanonicalFilePath(canonicalizingIfPossible: pathURL)
        #expect(!cpath.isCanonical)
        #expect(cpath.string == pathString)
    }

    // MARK: - Inits: FilePath

    @available(macOS 12.0, *)
    @Test
    func init_canonicalizing_filePath_knownPathA() throws {
        let cpath = try CanonicalFilePath(canonicalizing: FilePath("/users"))
        #expect(cpath.isCanonical)
        #expect(cpath.string == "/Users")
    }

    @available(macOS 12.0, *)
    @Test
    func init_canonicalizing_filePath_knownPathB() throws {
        let tempDir = FilePath.temporaryDirectory
        #expect(tempDir.string.starts(with: "/var"))

        // path canonicalization adds `/private` to start of temporary directory path.
        let cpath = try CanonicalFilePath(canonicalizing: tempDir)
        #expect(cpath.isCanonical)
        #expect(cpath.string.starts(with: "/private/var"))
    }

    @available(macOS 12.0, *)
    @Test
    func init_canonicalizing_filePath_unknownPath() throws {
        let path = FilePath("/This/path/Does/not/Exist/\(UUID().uuidString)")
        #expect(throws: (any Error).self) { try CanonicalFilePath(canonicalizing: path) }
    }

    @available(macOS 12.0, *)
    @Test
    func init_canonicalizingIfPossible_filePath_knownPath() {
        let cpath = CanonicalFilePath(canonicalizingIfPossible: FilePath("/users"))
        #expect(cpath.isCanonical)
        #expect(cpath.string == "/Users")
    }

    @available(macOS 12.0, *)
    @Test
    func init_canonicalizingIfPossible_filePath_unknownPath() {
        let pathString = "/This/path/Does/not/Exist/\(UUID().uuidString)"
        let path = FilePath(pathString)
        let cpath = CanonicalFilePath(canonicalizingIfPossible: path)
        #expect(!cpath.isCanonical)
        #expect(cpath.string == pathString)
    }

    // MARK: - Equatable

    @available(macOS 12.0, *)
    @Test
    func equatable() {
        #expect(
            CanonicalFilePath(canonicalizingIfPossible: "/users")
                == CanonicalFilePath(canonicalizingIfPossible: "/users")
        )

        let uniqueName = "\(UUID().uuidString)"

        #expect(
            CanonicalFilePath(canonicalizingIfPossible: "/users/\(uniqueName)", partial: false)
                == CanonicalFilePath(canonicalizingIfPossible: "/users/\(uniqueName)", partial: false)
        )

        // case mismatch; == will re-evaluate non-canonical instances with partial==true to attempt fuzzy match
        #expect(
            CanonicalFilePath(canonicalizingIfPossible: "/users/\(uniqueName)", partial: false)
                == CanonicalFilePath(canonicalizingIfPossible: "/users/\(uniqueName)", partial: true)
        )
    }

    @available(macOS 12.0, *)
    @Test
    func isEqual() {
        #expect(
            CanonicalFilePath(canonicalizingIfPossible: "/users")
                .isEqual(to: CanonicalFilePath(canonicalizingIfPossible: "/users"))
            == .equal
        )

        #expect(
            CanonicalFilePath(canonicalizingIfPossible: "/users")
                .isEqual(to: CanonicalFilePath(canonicalizingIfPossible: "/uSers"))
            == .equal
        )

        let uniqueName = "\(UUID().uuidString)"

        #expect(
            CanonicalFilePath(canonicalizingIfPossible: "/users/\(uniqueName)", partial: false)
                .isEqual(to: CanonicalFilePath(canonicalizingIfPossible: "/users/\(uniqueName)", partial: false))
            == .equal
        )

        // case mismatch; == will re-evaluate non-canonical instances with partial==true to attempt fuzzy match
        #expect(
            CanonicalFilePath(canonicalizingIfPossible: "/users/\(uniqueName)", partial: false)
                .isEqual(to: CanonicalFilePath(canonicalizingIfPossible: "/users/\(uniqueName)", partial: true))
            == .equalAfterRecanonicalization(partial: true)
        )
    }

    // MARK: - Codable

    @available(macOS 12.0, *)
    @Test
    func filePath_encode_decode() throws {
        let encoder = JSONEncoder()
        let path = FilePath("/users")
        let encoded = try encoder.encode(path)

        let decodedPath = try JSONDecoder().decode(FilePath.self, from: encoded)
        #expect(decodedPath == FilePath("/users"))

        let decodedCPath = try JSONDecoder().decode(CanonicalFilePath.self, from: encoded)
        #expect(decodedCPath.wrapped == FilePath("/Users")) // auto-canonicalizes upon decode
    }

    @available(macOS 12.0, *)
    @Test
    func canonicalFilePath_encode_decode() throws {
        let encoder = JSONEncoder()
        let cpath = try CanonicalFilePath(canonicalizing: "/users")
        let encoded = try encoder.encode(cpath)

        let decodedPath = try JSONDecoder().decode(FilePath.self, from: encoded)
        #expect(decodedPath == cpath.wrapped)

        let decodedCPath = try JSONDecoder().decode(CanonicalFilePath.self, from: encoded)
        #expect(decodedCPath == cpath)
    }

    // MARK: - FilePath Native Forwarded Methods & Properties

    // since methods under this mark are just proxy methods to access the wrapper, we won't bother testing all of them
    // since all of them are already tested in the corresponding `FilePath` tests.

    @available(macOS 12.0, *)
    @Test
    func mutatingLastPathComponent() {
        #expect(
            CanonicalFilePath(canonicalizingIfPossible: "/users/shared/some file.txt", partial: false)
                .mutatingLastPathComponent { "a" + $0.string + ".pdf" } // re-canonicalizes if necessary
                .string
            == "/Users/Shared/asome file.txt.pdf"
        )

        #expect(
            CanonicalFilePath(canonicalizingIfPossible: "/users/shared/some file.txt", partial: false)
                .mutatingLastPathComponent { _ in "new file name" } // re-canonicalizes if necessary
                .string
            == "/Users/Shared/new file name"
        )
    }

    @available(macOS 12.0, *)
    @Test
    func mutatingLastPathComponentExcludingExtension() {
        #expect(
            CanonicalFilePath(canonicalizingIfPossible: "/users/shared/some file.txt", partial: false)
                .mutatingLastPathComponentExcludingExtension { "a" + $0 + "b" } // re-canonicalizes if necessary
                .string
            == "/Users/Shared/asome fileb.txt"
        )

        #expect(
            CanonicalFilePath(canonicalizingIfPossible: "/users/shared/some file.txt", partial: false)
                .mutatingLastPathComponentExcludingExtension { _ in "new file name" } // re-canonicalizes if necessary
                .string
            == "/Users/Shared/new file name.txt"
        )
    }

    @available(macOS 12.0, *)
    @Test
    func appendingToLastPathComponentBeforeExtension() {
        #expect(
            CanonicalFilePath(canonicalizingIfPossible: "/users/shared/some file.txt", partial: false)
                .appendingToLastPathComponentBeforeExtension("-2") // re-canonicalizes if necessary
                .string
            == "/Users/Shared/some file-2.txt"
        )
    }

    // MARK: - FilePath SwiftExtensions-Defined Forwarded Methods & Properties

    // since methods under this mark are just proxy methods to access the wrapper, we won't bother testing all of them
    // since all of them are already tested in the corresponding `FilePath` tests.

    @available(macOS 12.0, *)
    @Test
    func append_components() throws {
        var path = CanonicalFilePath(canonicalizingIfPossible: "/users")
        #expect(path.isCanonical)
        #expect(path.string == "/Users")

        path.append([FilePath.Component("shared")])
        #expect(path.isCanonical)
        #expect(path.string == "/Users/Shared")

        let uniqueName = "\(UUID().uuidString)"
        try path.append([#require(FilePath.Component(uniqueName))])
        #expect(path.isCanonical)
        #expect(path.string == "/Users/Shared/\(uniqueName)")
    }

    @available(macOS 12.0, *)
    @Test
    func appending_components() throws {
        var path = CanonicalFilePath(canonicalizingIfPossible: "/users")
        #expect(path.isCanonical)
        #expect(path.string == "/Users")

        path = path.appending([FilePath.Component("shared")])
        #expect(path.isCanonical)
        #expect(path.string == "/Users/Shared")

        let uniqueName = "\(UUID().uuidString)"
        path = try path.appending([#require(FilePath.Component(uniqueName))])
        #expect(path.isCanonical)
        #expect(path.string == "/Users/Shared/\(uniqueName)")
    }

    @available(macOS 12.0, *)
    @Test
    func append_string() {
        var path = CanonicalFilePath(canonicalizingIfPossible: "/users")
        #expect(path.isCanonical)
        #expect(path.string == "/Users")

        path.append("shared")
        #expect(path.isCanonical)
        #expect(path.string == "/Users/Shared")

        let uniqueName = "\(UUID().uuidString)"
        path.append(uniqueName)
        #expect(path.isCanonical)
        #expect(path.string == "/Users/Shared/\(uniqueName)")
    }

    @available(macOS 12.0, *)
    @Test
    func appending_string() {
        var path = CanonicalFilePath(canonicalizingIfPossible: "/users")
        #expect(path.isCanonical)
        #expect(path.string == "/Users")

        path = path.appending("shared")
        #expect(path.isCanonical)
        #expect(path.string == "/Users/Shared")

        let uniqueName = "\(UUID().uuidString)"
        path = path.appending(uniqueName)
        #expect(path.isCanonical)
        #expect(path.string == "/Users/Shared/\(uniqueName)")
    }

    @available(macOS 12.0, *)
    @Test
    func append_component() throws {
        var path = CanonicalFilePath(canonicalizingIfPossible: "/users")
        #expect(path.isCanonical)
        #expect(path.string == "/Users")

        path.append(FilePath.Component("shared"))
        #expect(path.isCanonical)
        #expect(path.string == "/Users/Shared")

        let uniqueName = "\(UUID().uuidString)"
        try path.append(#require(FilePath.Component(uniqueName)))
        #expect(path.isCanonical)
        #expect(path.string == "/Users/Shared/\(uniqueName)")
    }

    @available(macOS 12.0, *)
    @Test
    func appending_component() throws {
        var path = CanonicalFilePath(canonicalizingIfPossible: "/users")
        #expect(path.isCanonical)
        #expect(path.string == "/Users")

        path = path.appending(FilePath.Component("shared"))
        #expect(path.isCanonical)
        #expect(path.string == "/Users/Shared")

        let uniqueName = "\(UUID().uuidString)"
        path = try path.appending(#require(FilePath.Component(uniqueName)))
        #expect(path.isCanonical)
        #expect(path.string == "/Users/Shared/\(uniqueName)")
    }

    @available(macOS 12.0, *)
    @Test
    func removingLastComponent() {
        let uniqueName = "\(UUID().uuidString)"

        var path = CanonicalFilePath(canonicalizingIfPossible: "/users/\(uniqueName)", partial: false)
        #expect(!path.isCanonical)
        #expect(path.string == "/users/\(uniqueName)")

        path = path.removingLastComponent() // re-canonicalizes if necessary
        #expect(path.isCanonical)
        #expect(path.string == "/Users")

        path = path.removingLastComponent()
        #expect(path.isCanonical)
        #expect(path.string == "/")

        path = path.removingLastComponent()
        #expect(path.isCanonical)
        #expect(path.string == "/") // no change; root is preserved
    }

    @available(macOS 12.0, *)
    @Test
    func removeLastComponent() {
        let uniqueName = "\(UUID().uuidString)"

        var path = CanonicalFilePath(canonicalizingIfPossible: "/users/\(uniqueName)", partial: false)
        #expect(!path.isCanonical)
        #expect(path.string == "/users/\(uniqueName)")

        #expect(path.removeLastComponent() == true) // re-canonicalizes if necessary
        #expect(path.isCanonical)
        #expect(path.string == "/Users")

        #expect(path.removeLastComponent() == true)
        #expect(path.isCanonical)
        #expect(path.string == "/")

        #expect(path.removeLastComponent() == false)
        #expect(path.isCanonical)
        #expect(path.string == "/") // no change; root is preserved
    }

    /// Spot-check one of the static properties.
    @available(macOS 13.0, *)
    @Test
    func temporaryDirectory() throws {
        let tempPath = try URL.temporaryDirectory.canonicalizingFileURL().path
        #expect(CanonicalFilePath.temporaryDirectory.string == tempPath)
    }

    // MARK: - FilePath Extension Methods

    @available(macOS 12.0, *)
    @Test
    func filePath_asCanonicalFilePath() throws {
        #expect(
            try FilePath("/users").asCanonicalFilePath(partial: false)
                == CanonicalFilePath(canonicalizing: "/users", partial: false)
        )

        let uniqueName = "\(UUID().uuidString)"

        #expect(
            try FilePath("/users/\(uniqueName)").asCanonicalFilePath(partial: true)
                == CanonicalFilePath(canonicalizing: "/users/\(uniqueName)", partial: true)
        )
    }

    @available(macOS 12.0, *)
    @Test
    func filePath_asCanonicalFilePathIfPossible() {
        #expect(
            FilePath("/users").asCanonicalFilePathIfPossible(partial: false)
                == CanonicalFilePath(canonicalizingIfPossible: "/users", partial: false)
        )

        let uniqueName = "\(UUID().uuidString)"

        #expect(
            FilePath("/users/\(uniqueName)").asCanonicalFilePathIfPossible(partial: true)
                == CanonicalFilePath(canonicalizingIfPossible: "/users/\(uniqueName)", partial: true)
        )
    }

    // MARK: - URL Extension Methods

    @available(macOS 12.0, *)
    @Test
    func url_asCanonicalFilePath() throws {
        #expect(
            try URL(fileURLWithPath: "/users").asCanonicalFilePath(partial: false)
                == CanonicalFilePath(canonicalizing: "/users", partial: false)
        )

        let uniqueName = "\(UUID().uuidString)"

        #expect(
            try URL(fileURLWithPath: "/users/\(uniqueName)").asCanonicalFilePath(partial: true)
                == CanonicalFilePath(canonicalizing: "/users/\(uniqueName)", partial: true)
        )
    }

    @available(macOS 12.0, *)
    @Test
    func url_asCanonicalFilePathIfPossible() {
        #expect(
            URL(fileURLWithPath: "/users").asCanonicalFilePathIfPossible(partial: false)
                == CanonicalFilePath(canonicalizingIfPossible: "/users", partial: false)
        )

        let uniqueName = "\(UUID().uuidString)"

        #expect(
            URL(fileURLWithPath: "/users/\(uniqueName)").asCanonicalFilePathIfPossible(partial: true)
                == CanonicalFilePath(canonicalizingIfPossible: "/users/\(uniqueName)", partial: true)
        )
    }
}

#endif
