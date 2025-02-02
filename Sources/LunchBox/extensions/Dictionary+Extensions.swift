//
//  Dictionary+Utils.swift
//
//
//  Created by Luis Alvarez on 9/14/23.
//

import SwiftUI

public extension Dictionary {
    /// Checks if the dictionary contains a specific key
    /// - Parameter key: The key to check for
    /// - Returns: `true` if the key exists in the dictionary, `false` otherwise
    /// - Complexity: O(1) on average
    public func containsKey(_ key: Key) -> Bool {
        index(forKey: key) != nil
    }
}
