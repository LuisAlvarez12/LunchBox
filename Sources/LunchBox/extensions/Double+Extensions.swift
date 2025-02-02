//
//  Double+Extensions.swift
//  LunchBox
//
//  Created by Luis Alvarez on 2/2/25.
//
import Foundation

public extension Double? {
    /// Converts an optional Double to a string representation
    /// - Returns: The string value of the double if it's greater than 0,
    ///           "N/A" if the double is nil or less than or equal to 0
    public var safeString: String {
        if let _double = self {
            if _double > 0 {
                return "\(_double)"
            } else {
                return "N/A"
            }
        }
        return "N/A"
    }
}
