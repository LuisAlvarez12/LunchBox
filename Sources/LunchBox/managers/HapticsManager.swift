//
//  HapticsManager.swift
//
//
//  Created by Luis Alvarez on 9/14/23.
//

import SwiftUI

public struct HapticsManager {
    public static let shared = HapticsManager()

    public func onGeneral() {
//        UINotificationFeedbackGenerator().notificationOccurred(.success)
    }

    public func onError() {
//        UINotificationFeedbackGenerator().notificationOccurred(.error)
    }
}
