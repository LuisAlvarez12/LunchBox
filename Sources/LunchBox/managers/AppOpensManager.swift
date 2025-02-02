//
//  AppOpensManager.swift
//
//
//  Created by Luis Alvarez on 9/14/23.
//

import StoreKit
import SwiftUI

/// Manages app launch counts and review prompts
public class AppOpensManager {
    /// Shared instance of the app opens manager
    public static let shared = AppOpensManager()

    /// Storage key for tracking number of app launches
    private static let TIMES_LOGGED_IN = "timesLoggedIn"
    /// Storage key for tracking number of times review prompt has been shown
    private static let HAS_SEEN_REVIEW_PROMPT = "timesSeenReviewPrompt"

    /// Array of app launch counts at which to show membership prompt
    private let timesToShowMembership = [3, 8, 12, 15, 20]

    /// Number of times the user has launched the app
    @AppStorage(AppOpensManager.TIMES_LOGGED_IN) private var timesLoggedIn: Int = 0
    /// Number of times the review prompt has been shown
    @AppStorage(AppOpensManager.HAS_SEEN_REVIEW_PROMPT) private var timesSeenReviewPrompt: Int = 0

    /// Called when the app is launched or brought to foreground
    /// Handles review prompts and membership prompts based on launch count
    @MainActor
    public func onEnteredApp() {
        timesLoggedIn += 1

        if timesToShowMembership.contains(where: { $0 == timesLoggedIn }) {
        } else if timesSeenReviewPrompt == 0 {
            if timesLoggedIn == 4 {
                timesSeenReviewPrompt += 1

                // try getting current scene
                guard let currentScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
                    return
                }

                // show review dialog
                SKStoreReviewController.requestReview(in: currentScene)
            }
        }
    }
}
