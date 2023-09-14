//
//  Number+Extensions.swift
//  
//
//  Created by Luis Alvarez on 9/13/23.
//

import Foundation

public extension Int {
    public func nano() -> UInt64 {
        UInt64(self * 1_000_000_000)
    }
}

public extension Double {
    public func nano() -> UInt64 {
        UInt64(self * 1_000_000_000)
    }
}
