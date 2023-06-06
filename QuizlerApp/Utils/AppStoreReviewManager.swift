//
//  AppStoreReviewManager.swift
//  QuizlerApp
//
//  Created by Petar Sakotic on 5/29/23.
//

import Foundation
import StoreKit

enum AppStoreReviewManager {
    
    static func requestReviewIfAppropriate() {
        if #available(iOS 14.0, *) {
            if let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
                SKStoreReviewController.requestReview(in: scene)
            }
        } else {
            SKStoreReviewController.requestReview()
        }
    }
    
}
