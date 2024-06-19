//
//  AppOpensManager.swift
//
//
//  Created by Luis Alvarez on 9/14/23.
//

import StoreKit
import SwiftUI

public class AppOpensManager {
    public static let shared = AppOpensManager()

    private static let TIMES_LOGGED_IN = "timesLoggedIn"
    private static let HAS_SEEN_REVIEW_PROMPT = "timesSeenReviewPrompt"

    private let timesToShowMembership = [3, 8, 12, 15, 20]

    @AppStorage(AppOpensManager.TIMES_LOGGED_IN) var timesLoggedIn: Int = 0
    @AppStorage(AppOpensManager.HAS_SEEN_REVIEW_PROMPT) var timesSeenReviewPrompt: Int = 0

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
