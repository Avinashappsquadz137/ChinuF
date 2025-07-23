//
//  NotificationHandler.swift
//  SanskarEPUI
//
//  Created by Sanskar IOS Dev on 11/07/25.
//
import SwiftUI
// MARK: - Observable Handler
class NotificationHandler: ObservableObject {
    static let shared = NotificationHandler()
    
    @Published var showGuestPopup = false
    @Published var selectedPushData: PushHistory?
    @Published var navigateToNotificationScreen = false
    private init() {}
    
    func handleNotification(data: [String: Any]) {
        if let type = data["notification_type"] as? String, type == "8" {
            var item = PushHistory()
            item.notification_type = type
            item.notification_content = data["notification_content"] as? String
            item.notification_thumbnail = data["notification_thumbnail"] as? String
            item.req_id = {
                if let val = data["req_id"] as? Int {
                    return val
                } else if let val = data["req_id"] as? String {
                    return Int(val) ?? 0
                } else {
                    return 0
                }
            }()
            self.selectedPushData = item
            self.showGuestPopup = true
            self.navigateToNotificationScreen = true
        }
    }
}

