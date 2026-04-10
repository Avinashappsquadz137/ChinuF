//
//  BadgeManager.swift
//  SanskarEPUI
//
//  Created by Sanskar IOS Dev on 24/03/26.
//
import UserNotifications
import UIKit

class BadgeManager {
    
    static func update(count: Int) {
        if #available(iOS 17.0, *) {
            UNUserNotificationCenter.current().setBadgeCount(count) { error in
                if let error = error {
                    print("Badge update error: \(error.localizedDescription)")
                }
            }
        } else {
            UIApplication.shared.applicationIconBadgeNumber = count
        }
    }
}
