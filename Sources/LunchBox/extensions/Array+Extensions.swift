//
//  Array+Extensions.swift
//  UnderCovers
//
//  Created by Luis Alvarez on 12/23/24.
//
import Foundation

public extension Array {
    /// Safely retrieves an element at the specified index
    ///
    /// - Parameter index: The index of the element to retrieve
    /// - Returns: The element at the specified index if it exists, nil otherwise
    /// - Complexity: O(1)
    public func safeIndex(_ index: Int) -> Element? {
        guard index >= 0, index < count else { return nil }
        return self[index]
    }
}
