//
//  Number+Extensions.swift
//  
//
//  Created by Luis Alvarez on 9/13/23.
//

import Foundation

extension Int {
    func nano() -> UInt64 {
        UInt64(self * 1_000_000_000)
    }
}

extension Double {
    func nano() -> UInt64 {
        UInt64(self * 1_000_000_000)
    }
}
