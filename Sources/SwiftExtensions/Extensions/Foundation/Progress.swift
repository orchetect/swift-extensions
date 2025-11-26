//
//  Progress.swift
//  swift-extensions • https://github.com/orchetect/swift-extensions
//  © 2025 Steffan Andrews • Licensed under MIT License
//

#if canImport(Foundation)

import Foundation

extension Progress {
    /// Returns the parent `Progress` instance, if one is attached.
    @_disfavoredOverload
    public var parent: Progress? {
        autoreleasepool {
            // keyPath "_parent" also works
            let getParent = value(forKeyPath: "parent")
            let typedParent = getParent as? Progress
            return typedParent
        }
    }
    
    /// Returns all child `Progress` instances that are attached.
    @_disfavoredOverload
    public var children: Set<Progress> {
        autoreleasepool {
            // keyPath "_children" also works
            let getChildren = value(forKeyPath: "children")
            guard let nsSet = getChildren as? NSSet else { return [] }
            let mappedChildren = nsSet.compactMap { $0 as? Progress }
            let mappedSet = Set(mappedChildren)
            return mappedSet
        }
    }
}

#endif
