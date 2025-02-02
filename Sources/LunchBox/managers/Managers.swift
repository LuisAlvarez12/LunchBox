//
//  Managers.swift
//  LunchBox
//
//  Created by Luis Alvarez on 2/2/25.
//

/**
 This is the struct that is allows for shortcut access to all of the managers accessible to
 */
public struct Managers {
    
    public static let appOpens = AppOpensManager.shared
    public static let biometrics = BiometricsManager.shared
    public static let haptics = HapticsManager.shared
    public static let purchases = PurchasesManager.shared
    public static let notifications = PurchasesManager.shared
    public static let logger = LunchLogger.shared

}
