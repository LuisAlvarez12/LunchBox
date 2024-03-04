//
//  HapticsManager.swift
//
//
//  Created by Luis Alvarez on 9/14/23.
//

import SwiftUI

public struct HapticsManager {
    public static let shared = HapticsManager()
    
#if os(iOS)
    private let hapticsHandler = UINotificationFeedbackGenerator()
#endif
    
    public func onGeneral() {
#if os(iOS)
        hapticsHandler.notificationOccurred(.success)
#endif
        
    }
    
    public func onError() {
#if os(iOS)
        hapticsHandler.notificationOccurred(.error)
#endif
    }
}
