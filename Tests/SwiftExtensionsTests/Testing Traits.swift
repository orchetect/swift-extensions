//
//  Testing Traits.swift
//  swift-extensions • https://github.com/orchetect/swift-extensions
//  © 2025 Steffan Andrews • Licensed under MIT License
//

import Testing

/// See: https://docs.github.com/en/actions/reference/workflows-and-actions/variables
/// "GITHUB_ACTIONS"
func isRunningOnGitHubActions() -> Bool {
    #if GITHUB_ACTIONS
    return true
    #else
    return false
    #endif
}

#if canImport(Foundation)

import Foundation

/// Returns `true` if the system Trash directory is accessible.
func isTrashDirectoryAccessible() -> Bool {
    #if os(macOS) || os(iOS) || os(visionOS)
    (try? FileManager.default.url(for: .trashDirectory, in: .userDomainMask, appropriateFor: nil, create: false)) != nil
    #else
    // unavailable on tvOS and watchOS
    false
    #endif
}

extension Trait where Self == ConditionTrait {
    /// Test trait that checks if the system Trash directory is accessible.
    ///
    /// There seems to be a bug where calling `URL.trashDirectory` on an iOS Simulator causes a EXC_BAD_INSTRUCTION crash.
    ///
    /// Usage:
    ///
    /// ```swift
    /// @Test(.enabledIfTrashDirectoryIsAccessible)
    /// func mytest() { /* ... */ }
    /// ```
    static var enabledIfTrashDirectoryIsAccessible: ConditionTrait {
        .enabled(if: isTrashDirectoryAccessible())
    }
}

#endif
