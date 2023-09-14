//
//  AsyncResponse.swift
//  
//
//  Created by Luis Alvarez on 9/14/23.
//

import SwiftUI

@available(iOS 13.0, *)
protocol AsyncResponse {}

struct AsyncSuccess: AsyncResponse {}

struct AsyncFailure: AsyncResponse, Error {
    var error: ErrorDetails? = nil
}

struct ErrorDetails {
    let message: String
}
