//
//  BiometricsManager.swift
//
//
//  Created by Luis Alvarez on 9/14/23.
//

import LocalAuthentication
import SwiftUI

/// Manager for handling biometric authentication (e.g., Face ID)
@available(iOS 16, *)
public struct BiometricsManager {
    /// Shared instance of the biometrics manager
    public static let shared = BiometricsManager()

    /// Attempts to authenticate the user using Face ID
    /// - Returns: An AuthResult indicating success or failure of the authentication
    public func faceIDCheck() async -> AuthResult {
        let context = LAContext()
        var error: NSError?

        // check whether biometric authentication is possible
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            // it's possible, so go ahead and use it
            let reason = String(localized: "We need to unlock your data.")

            do {
                let result = try await context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason)
                return result ? AuthSuccess() : AuthError(errorMessage: "Failed to authenticate via FaceID")
            } catch {
                return AuthError(errorMessage: "Failed to login with FaceID")
            }
        } else {
            return AuthSuccess()
        }
    }
}

/// Protocol representing the result of an authentication attempt
public protocol AuthResult {}

/// Represents a successful authentication
public struct AuthSuccess: AuthResult {}

/// Represents a failed authentication with an error message
public struct AuthError: AuthResult {
    /// The error message describing why authentication failed
    public var errorMessage = "Login Failed"
}
