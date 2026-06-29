//
//  Task Extensions.swift
//  SwiftExtensions • https://github.com/orchetect/swift-extensions
//  © 2026 Steffan Andrews • Licensed under MIT License
//

#if canImport(Darwin)
import struct Foundation.Date
import var Foundation.NSEC_PER_SEC // also in CoreFoundation
import typealias Foundation.TimeInterval
#else
import struct FoundationEssentials.Date
import typealias FoundationEssentials.TimeInterval

private let NSEC_PER_SEC: UInt64 = 1_000_000_000
#endif

@available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
extension Task where Success == Never, Failure == Never {
    /// Suspends the current task for at least the given duration in seconds.
    ///
    /// If the task is canceled before the time ends, this function throws `CancellationError`.
    ///
    /// This function doesn't block the underlying thread.
    @_disfavoredOverload
    package static func sleep(seconds: TimeInterval) async throws {
        let intervalNS = UInt64(seconds * TimeInterval(NSEC_PER_SEC))
        try await sleep(nanoseconds: intervalNS)
    }
}
