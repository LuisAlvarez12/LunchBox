//
//  HapticsManager.swift
//
//
//  Created by Luis Alvarez on 9/14/23.
//

import SwiftUI

public struct HapticsManager {
    public static let shared = HapticsManager()
    private let generator = UINotificationFeedbackGenerator()

    public func onGeneral() {
        generator.notificationOccurred(.success)
    }

    public func onError() {
        generator.notificationOccurred(.error)
    }
}
