//
//  HapticsManager.swift
//
//  Created by Luis Alvarez on 9/14/23.
//

import SwiftUI

/// Manager for handling haptic feedback across different platforms
@Observable
public class HapticsManager {
    /// Shared instance of the haptics manager
    public static let shared = HapticsManager()

    /// Current haptic feedback data
    public var feedbackHandler: HapticsData = .init()

    /// Triggers a general haptic feedback
    public func onGeneral() {
        #if os(iOS)
            feedbackHandler = HapticsData()
        #endif
    }

    /// Triggers an error haptic feedback
    public func onError() {
        #if os(iOS)
            feedbackHandler = HapticsData(feedback: .error)
        #endif
    }
}

/// Extension to add haptic feedback support to SwiftUI views
public extension View {
    /// Adds haptic feedback receiver to the view
    /// - Returns: A view that responds to haptic feedback events
    func hapticsReciever() -> some View {
        #if os(iOS)
            sensoryFeedback(HapticsManager.shared.feedbackHandler.feedback, trigger: HapticsManager.shared.feedbackHandler)
        #else
            self
        #endif
    }
}

#if os(iOS)
    /// Data structure for haptic feedback on iOS
    public struct HapticsData: Equatable {
        /// The type of sensory feedback
        public var feedback: SensoryFeedback = .increase
        /// Unique identifier for the feedback event
        public var id = UUID()

        /// Creates a new haptic feedback data instance
        /// - Parameters:
        ///   - feedback: The type of sensory feedback (default: .increase)
        ///   - id: Unique identifier for the feedback event
        public init(feedback: SensoryFeedback = .increase, id: UUID = UUID()) {
            self.feedback = feedback
            self.id = id
        }

        public static func == (lhs: HapticsData, rhs: HapticsData) -> Bool {
            return lhs.id == rhs.id
        }
    }
#else
    /// Data structure for haptic feedback on non-iOS platforms
    public struct HapticsData: Equatable {
        /// Unique identifier for the feedback event
        public var id = UUID()

        /// Creates a new haptic feedback data instance
        /// - Parameter id: Unique identifier for the feedback event
        public init(id: UUID = UUID()) {
            self.id = id
        }

        public static func == (lhs: HapticsData, rhs: HapticsData) -> Bool {
            return lhs.id == rhs.id
        }
    }
#endif
