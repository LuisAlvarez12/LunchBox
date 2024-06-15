//
//  HapticsManager.swift
//
//  Created by Luis Alvarez on 9/14/23.
//

import SwiftUI

@Observable
public class HapticsManager {
    public static let shared = HapticsManager()

    public var feedbackHandler: HapticsData = .init()

    public func onGeneral() {
        feedbackHandler = HapticsData()
    }

    public func onError() {
        feedbackHandler = HapticsData(feedback: .error)
    }
}

public extension View {
    public func hapticsReciever() -> some View {
        sensoryFeedback(HapticsManager.shared.feedbackHandler.feedback, trigger: HapticsManager.shared.feedbackHandler)
    }
}

public struct HapticsData: Equatable {
    public var feedback: SensoryFeedback = .increase
    public var id = UUID()
    
    public init(feedback: SensoryFeedback = .increase, id: UUID = UUID()) {
        self.feedback = feedback
        self.id = id
    }

    public static func == (lhs: HapticsData, rhs: HapticsData) -> Bool {
        return lhs.id == rhs.id
    }
}

