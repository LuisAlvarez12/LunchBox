//
//  String+Extensions.swift
//
//
//  Created by Luis Alvarez on 9/13/23.
//

import Foundation

extension String? {
    /// Returns the string value or an empty string if nil
    /// - Returns: The string value if not nil, otherwise returns an empty string
    public func orEmpty() -> String {
        self ?? ""
    }
}

public extension String {
    /// Extracts a substring between two strings
    /// - Parameters:
    ///   - from: The starting string
    ///   - to: The ending string
    /// - Returns: The substring between 'from' and 'to', or nil if either string is not found
    public func slice(from: String, to: String) -> String? {
        guard let rangeFrom = range(of: from)?.upperBound else { return nil }
        guard let rangeTo = self[rangeFrom...].range(of: to)?.lowerBound else { return nil }
        return String(self[rangeFrom ..< rangeTo])
    }

    /// Extracts a substring between three strings
    /// - Parameters:
    ///   - from: The starting string
    ///   - intermediate: The intermediate string
    ///   - to: The ending string
    /// - Returns: The substring between 'intermediate' and 'to', or nil if any string is not found
    public func slice(from: String, intermediate: String, to: String) -> String? {
        guard let rangeFrom = range(of: from)?.upperBound else { return nil }
        guard let rangeIntermed = self[rangeFrom...].range(of: intermediate)?.upperBound else { return nil }
        guard let rangeTo = self[rangeIntermed...].range(of: to)?.lowerBound else { return nil }
        return String(self[rangeIntermed ..< rangeTo])
    }
}

public extension Collection {
    /// Indicates whether the collection contains any elements
    /// - Returns: `true` if the collection is not empty, `false` otherwise
    public var isNotEmpty: Bool {
        return !isEmpty
    }
}

public extension String? {
    /// Returns either the valid string or a fallback value
    /// - Parameter fallback: The string to return if this string is nil or empty
    /// - Returns: The original string if it exists and is not empty, otherwise the fallback string
    public func validOr(_ fallback: String) -> String {
        if let str = self, str.trimmingCharacters(in: .whitespacesAndNewlines).isNotEmpty {
            return str
        } else {
            return fallback
        }
    }
}
