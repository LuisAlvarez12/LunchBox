//
//  AsyncResponse.swift
//  
//
//  Created by Luis Alvarez on 9/14/23.
//

import SwiftUI

@available(iOS 13.0, *)
public protocol AsyncResponse {}

public struct AsyncSuccess: AsyncResponse {}

public struct AsyncFailure: AsyncResponse, Error {
    var error: ErrorDetails? = nil
}

public struct ErrorDetails {
    let message: String
}
