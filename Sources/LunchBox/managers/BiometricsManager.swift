//
//  BiometricsManager.swift
//  
//
//  Created by Luis Alvarez on 9/14/23.
//

import LocalAuthentication
import SwiftUI

@available(iOS 16, *)
struct BiometricsManager {
    static let shared = BiometricsManager()

    func faceIDCheck() async -> AuthResult {
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

protocol AuthResult {}

struct AuthSuccess: AuthResult {}

struct AuthError: AuthResult {
    var errorMessage = "Login Failed"
}
