//
//  NotificationManager.swift
//  Rise
//
//  Created by Vladimir Korolev on 08.01.2021.
//  Copyright © 2021 VladimirBrejcha. All rights reserved.
//

import UserNotifications

public final class NotificationManager: NSObject {
    
    public static var isNotificationPermissionGranted: Bool {
        get {
            return UserDefaults.standard.bool(forKey: "NotificationPermissionGranted")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "NotificationPermissionGranted")
        }
    }
    
// MARK: - Request permission
    
    public static func requestNotificationPermission() {
        let notificationCenter = UNUserNotificationCenter.current()
        
        notificationCenter.requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
            guard granted else { return }
            notificationCenter.getNotificationSettings { (settings)  in
                log(.info, "Notification settings: \(settings)")
                guard settings.authorizationStatus == .authorized else
                { return }
                isNotificationPermissionGranted = true
            }
        }
    }
//MARK: - Create notification
    
    public static func createNotification(title: String, body: String, components: DateComponents, categoryIdentifier: String? = nil) {
        let notificationCenter = UNUserNotificationCenter.current()
        let notificationContent = UNMutableNotificationContent()
        
        notificationContent.title = title
        notificationContent.body = body
        notificationContent.sound = .default
        
        if let categoryIdentifier = categoryIdentifier {
              notificationContent.categoryIdentifier = categoryIdentifier
          }
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
        let request = UNNotificationRequest(identifier: "notification", content: notificationContent, trigger: trigger)
        notificationCenter.add(request)
    }
//MARK: - Cancel pending requests
    
    public static func cancelAllPendingRequests(){
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.removeAllPendingNotificationRequests()
    }
}
//MARK: - Extension

import UIKit
extension UIApplication {
    public static func openAppSettings() {
        guard let url = URL(string: UIApplication.openSettingsURLString) else {
            log(.error, "Cannot build settings url")
            return
        }
        UIApplication.shared.open(url, options: [:]) { done in
            log(.info, "Open settings request completed = \(done)")
        }
    }
}
