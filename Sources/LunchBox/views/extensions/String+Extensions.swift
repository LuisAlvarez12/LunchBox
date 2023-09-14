//
//  String+Extensions.swift
//  
//
//  Created by Luis Alvarez on 9/13/23.
//

import Foundation

public extension String {
    public  func slice(from: String, to: String) -> String? {
        guard let rangeFrom = range(of: from)?.upperBound else { return nil }
        guard let rangeTo = self[rangeFrom...].range(of: to)?.lowerBound else { return nil }
        return String(self[rangeFrom ..< rangeTo])
    }

    public func slice(from: String, intermediate: String, to: String) -> String? {
        guard let rangeFrom = range(of: from)?.upperBound else { return nil }
        guard let rangeIntermed = self[rangeFrom...].range(of: intermediate)?.upperBound else { return nil }
        guard let rangeTo = self[rangeIntermed...].range(of: to)?.lowerBound else { return nil }
        return String(self[rangeIntermed ..< rangeTo])
    }
}

public extension Collection {
    public var isNotEmpty: Bool {
        return !isEmpty
    }
}

public extension String? {
    public func validOr(_ fallback: String) -> String {
        if let str = self, str.trimmingCharacters(in: .whitespacesAndNewlines).isNotEmpty {
            return str
        } else {
            return fallback
        }
    }
}
