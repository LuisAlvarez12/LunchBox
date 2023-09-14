//
//  HapticsManager.swift
//  
//
//  Created by Luis Alvarez on 9/14/23.
//

import SwiftUI

struct HapticsManager {
    static let shared = HapticsManager()
    private let generator = UINotificationFeedbackGenerator()

    func onGeneral() {
        generator.notificationOccurred(.success)
    }

    func onError() {
        generator.notificationOccurred(.error)
    }
}
