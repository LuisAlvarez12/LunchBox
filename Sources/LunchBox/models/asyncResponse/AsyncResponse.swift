//
//  AsyncResponse.swift
//
//
//  Created by Luis Alvarez on 9/14/23.
//

import SwiftUI

/// Protocol representing the result of an asynchronous operation
@available(iOS 16.0, *)
public protocol AsyncResponse {}

/// Represents a successful asynchronous operation
public struct AsyncSuccess: AsyncResponse {}

/// Represents a failed asynchronous operation with optional error details
public struct AsyncFailure: AsyncResponse, Error {
    /// Optional details about the error that occurred
    public var error: ErrorDetails? = nil
}

/// Contains detailed information about an error
public struct ErrorDetails {
    /// A message describing the error
    public let message: String
}
