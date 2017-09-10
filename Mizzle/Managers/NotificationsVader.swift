//
//  NotificationsVader.swift
//  Mizzle
//
//  Created by Rahul Meena on 12/07/17.
//  Copyright © 2017 Ardour Labs. All rights reserved.
//

import UIKit
import UserNotifications

class NotificationsVader: NSObject {
    static let shared = NotificationsVader()
    
    func getNotificationPermission() {
        
        // iOS 10 support
        if #available(iOS 10, *) {
            UNUserNotificationCenter.current().requestAuthorization(options:[.badge, .alert, .sound]){ (granted, error) in }
            UIApplication.shared.registerForRemoteNotifications()
        }
            // iOS 9 support
        else if #available(iOS 9, *) {
            UIApplication.shared.registerUserNotificationSettings(UIUserNotificationSettings(types: [.badge, .sound, .alert], categories: nil))
            UIApplication.shared.registerForRemoteNotifications()
        }
    }
}
