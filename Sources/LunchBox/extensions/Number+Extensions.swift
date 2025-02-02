//
//  Number+Extensions.swift
//
//
//  Created by Luis Alvarez on 9/13/23.
//

import Foundation

public extension Int {
    /// Converts an integer to nanoseconds
    /// - Returns: The integer value converted to nanoseconds as UInt64
    public func nano() -> UInt64 {
        UInt64(self * 1_000_000_000)
    }
}

public extension Double {
    /// Converts a double to nanoseconds
    /// - Returns: The double value converted to nanoseconds as UInt64
    public func nano() -> UInt64 {
        UInt64(self * 1_000_000_000)
    }
}
