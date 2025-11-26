//
//  Testing Traits.swift
//  swift-extensions • https://github.com/orchetect/swift-extensions
//  © 2025 Steffan Andrews • Licensed under MIT License
//

// See: https://docs.github.com/en/actions/reference/workflows-and-actions/variables
// "GITHUB_ACTIONS"

func isRunningOnGitHubActions() -> Bool {
    #if GITHUB_ACTIONS
    return true
    #else
    return false
    #endif
}
