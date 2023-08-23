//
//  NotificationManager.swift
//  Rise
//
//  Created by Vladimir Korolev on 08.01.2021.
//  Copyright © 2021 VladimirBrejcha. All rights reserved.
//

import UserNotifications

public final class NotificationManager: NSObject {

    private let center = UNUserNotificationCenter.current()

    public override init() {
        super.init()
        let sleepCategory = UNNotificationCategory(identifier: "SleepCategory", actions: [], intentIdentifiers: [], options: [])
        UNUserNotificationCenter.current().setNotificationCategories([sleepCategory])
    }
    
    // MARK: - Permissions

    @discardableResult
    public func requestPermissions() async -> Bool {
        log(.info, "requestPermissions")
        do {
            return try await center
                .requestAuthorization(options: [.alert, .sound])
        } catch (let error) {
            log(.error, error.localizedDescription)
            return false
        }
    }

    public enum AuthorizationStatus {
        case notDetermined, authorized, denied
    }
    public func isAuthorized() async -> AuthorizationStatus {
        let settings = await center.notificationSettings()
        switch settings.authorizationStatus {
        case .notDetermined:
            return .notDetermined
        case .denied:
            return .denied
        case .authorized:
            return .authorized
        case .provisional:
            return .authorized
        case .ephemeral:
            return .authorized
        @unknown default:
            return .notDetermined
        }
    }
    
    // MARK: - Create notification
    
    public func createNotification(
        title: String,
        body: String,
        components: DateComponents,
        categoryIdentifier: String? = nil,
        identifier: String
    ) {
        let notificationContent = UNMutableNotificationContent()
        notificationContent.title = title
        notificationContent.body = body
        notificationContent.sound = .default
        if categoryIdentifier == "SleepCategory" {
            notificationContent.sound = .default
        } else {
            notificationContent.sound = UNNotificationSound(named: UNNotificationSoundName(rawValue: "DefaultMelody.wav"))
        }
        if let categoryIdentifier = categoryIdentifier {
            notificationContent.categoryIdentifier = categoryIdentifier
        }
        center.add(UNNotificationRequest(
            identifier: identifier,
            content: notificationContent,
            trigger: UNCalendarNotificationTrigger(
                dateMatching: components,
                repeats: false
            )
        ))
    }

    public func cleanDelivered() {
        center.removeAllDeliveredNotifications()
    }
}
