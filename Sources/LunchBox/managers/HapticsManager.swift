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
        #if os(iOS)
        feedbackHandler = HapticsData()
        #endif
    }

    public func onError() {
        #if os(iOS)
        feedbackHandler = HapticsData(feedback: .error)
        #endif
    }
}

public extension View {
    public func hapticsReciever() -> some View {
        #if os(iOS)
        sensoryFeedback(HapticsManager.shared.feedbackHandler.feedback, trigger: HapticsManager.shared.feedbackHandler)
        #else
        self
        #endif
    }
}
#if os(iOS)
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
#else
public struct HapticsData: Equatable {
    public var id = UUID()
    
    public init(id: UUID = UUID()) {
        self.id = id
    }

    public static func == (lhs: HapticsData, rhs: HapticsData) -> Bool {
        return lhs.id == rhs.id
    }
}
#endif
