//
//  HapticManager.swift
//  Crypto
//
//  Created by iCommunity app on 16/08/2024.
//

import Foundation
import SwiftUI

class HapticManager {
    private static let generator = UINotificationFeedbackGenerator()
    
    static func notification(type:  UINotificationFeedbackGenerator.FeedbackType) {
        generator.notificationOccurred(type)
    }
}
