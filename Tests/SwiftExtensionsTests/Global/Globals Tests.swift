//
//  Globals Tests.swift
//  swift-extensions • https://github.com/orchetect/swift-extensions
//  © 2026 Steffan Andrews • Licensed under MIT License
//

#if canImport(Foundation)

import Foundation
import SwiftExtensions
import Testing

@Suite
struct Global_Globals_Tests {
    @Test
    func bundle() {
        // this test could break in future versions of Xcode/XCTest
        // but we'll test what 'known values' we can here

        withKnownIssue(
            """
            This will only evaluate true if tests are run from Xcode/xcodebuild test. \
            If using swift test, this will be a different string.
            """,
            isIntermittent: true
        ) {
            #expect(Globals.MainBundle.name == "xctest")
        }

        withKnownIssue(
            """
            This will only evaluate true if tests are run from Xcode/xcodebuild test. \
            If using swift test, this will be a different string.
            """,
            isIntermittent: true
        ) {
            #expect(Globals.MainBundle.bundleID == "com.apple.dt.xctest.tool")
        }

        // XCTest in Xcode 12 and earlier doesn't return a value
        // So there isn't a meaningful way to test this
        //   Xcode 12.4 == ""
        //   Xcode 13   == "13.0"
        _ = Globals.MainBundle.versionShort

        // XCTest in Xcode 12 and earlier doesn't return a value
        // So there isn't a meaningful way to test this
        //   Xcode 12.4 == 0
        //   Xcode 13   == 13
        #expect(Globals.MainBundle.versionMajor > -1)

        withKnownIssue(
            """
            This will only evaluate true if tests are run from Xcode/xcodebuild test. \
            If using swift test, this will be a different string.
            """,
            isIntermittent: true
        ) {
            // XCTest appears to always return a non-empty value
            #expect(Globals.MainBundle.versionBuildNumber != "")
        }
    }

    @Test
    func system() async {
        // values cannot be tested explicitly since they vary by system

        #if os(macOS)
        _ = Globals.System.userName

        _ = Globals.System.fullUserName
        #endif

        #expect(Globals.System.osVersion != "")

        #expect(await Globals.System.name != "")

        #if os(macOS)
        #expect(Globals.System.serialNumber != nil)

        #expect(Globals.System.hardwareUUID != nil)
        #endif
    }

    @Test
    func bundle_infoDictionaryString() {
        // String key name

        withKnownIssue(
            """
            This will only evaluate true if tests are run from Xcode/xcodebuild test. \
            If using swift test, this will be a different string.
            """,
            isIntermittent: true
        ) {
            #expect(
                Bundle.main.infoDictionaryString(key: kCFBundleIdentifierKey as String) ==
                    "com.apple.dt.xctest.tool"
            )
        }

        // CFString key name

        withKnownIssue(
            """
            This will only evaluate true if tests are run from Xcode/xcodebuild test. \
            If using swift test, this will be a different string.
            """,
            isIntermittent: true
        ) {
            #expect(
                Bundle.main.infoDictionaryString(key: kCFBundleIdentifierKey) ==
                    "com.apple.dt.xctest.tool"
            )
        }
    }
}

#endif
