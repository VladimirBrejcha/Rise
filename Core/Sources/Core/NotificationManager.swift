//
//  NotificationManager.swift
//  Rise
//
//  Created by Vladimir Korolev on 08.01.2021.
//  Copyright © 2021 VladimirBrejcha. All rights reserved.
//

import UserNotifications

public final class NotificationManager: NSObject {
    
    //MARK: - Request permission
    
  public static func requestNotificationPermission() {
        let notificationCenter = UNUserNotificationCenter.current()
        
        notificationCenter.requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
            guard granted else { return }
            notificationCenter.getNotificationSettings { (settings)  in
                print("Notification settings: \(settings)")
                guard settings.authorizationStatus == .authorized else { return }
            }
        }
    }
//MARK: - Create notification
    
    public static func createNotification(title: String, body: String, components: DateComponents) {
        let notificationCenter = UNUserNotificationCenter.current()
        let notificationContent = UNMutableNotificationContent()
        
        notificationContent.title = title
        notificationContent.body = body
        notificationContent.categoryIdentifier = "notification"
        notificationContent.sound = .default
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
        let request = UNNotificationRequest(identifier: "notification", content: notificationContent, trigger: trigger)
        notificationCenter.add(request)
    }
//MARK: - Remove notification
    
    public static func removeNotification(){
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.removeAllPendingNotificationRequests()
    }
}
//MARK: - Extension

import UIKit
extension UIApplication {
    static func openAppSettings() {
        guard let url = URL(string: UIApplication.openSettingsURLString) else {
            log(.error, "Cannot build settings url")
            return
        }
        UIApplication.shared.open(url, options: [:]) { done in
            log(.info, "Open settings request completed = \(done)")
        }
    }
}
