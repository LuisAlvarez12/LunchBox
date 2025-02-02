//
//  Date+Extension.swift
//  UnderCovers
//
//  Created by Luis Alvarez on 12/7/24.
//
import SwiftUI

public extension Date {
    /// Converts the date to a human-readable relative time string
    ///
    /// Returns a localized string describing the time elapsed from this date to now
    /// (e.g., "2 hours ago", "3 days ago", etc.)
    ///
    /// - Returns: A localized string representing the relative time
    public func timeAgoDisplay() -> String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .full
        return formatter.localizedString(for: self, relativeTo: Date())
    }
}
