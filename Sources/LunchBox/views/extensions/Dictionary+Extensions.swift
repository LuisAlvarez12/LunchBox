//
//  Dictionary+Utils.swift
//  
//
//  Created by Luis Alvarez on 9/14/23.
//

import SwiftUI

public extension Dictionary {
    public  func containsKey(_ key: Key) -> Bool {
        index(forKey: key) != nil
    }
}
