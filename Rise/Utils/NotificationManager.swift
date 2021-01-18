//
//  NotificationManager.swift
//  Rise
//
//  Created by Владимир Королев on 08.01.2021.
//  Copyright © 2021 VladimirBrejcha. All rights reserved.
//

import UserNotifications

final class NotificationManager: NSObject, UNUserNotificationCenterDelegate {
    let notificationCenter = UNUserNotificationCenter.current()

    func configure() {
        notificationCenter.delegate = self
        notificationCenter.getNotificationSettings { [weak self] settings in
            guard let self = self else { return }
            switch settings.authorizationStatus {
            case .notDetermined:
                self.requestAuthorisation { granted in

                }
            case .denied:
                print("denied")
            case .authorized:
                print("ok")
            case .provisional:
                print("prov")
            case .ephemeral:
                print("def")
            @unknown default:
                print("def")
            }
        }
    }

    func requestAuthorisation(completion: @escaping (Bool) -> Void) {
        notificationCenter.requestAuthorization(
            options: [.alert, .sound]
        ) { granted, error in
            log(.info, "Authorisation granted = \(granted)\(error == nil ? "" : ", error = \(error!.localizedDescription)")")
            completion(granted)
        }
    }

    func requestToOpenSettings() {

    }

    func showNotification() {
        let content = UNMutableNotificationContent()
        content.title = "Alarm"
        content.body = "Wake and Rise!"

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 10, repeats: false)
        let uuid = UUID().uuidString
        let request = UNNotificationRequest(identifier: uuid, content: content, trigger: trigger)

        notificationCenter.add(request) { error in
            log(.info, "error = \(error?.localizedDescription ?? "nil")")
        }
    }

    // MARK: - UNUserNotificationCenterDelegate -
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
    ) {

    }

    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse,
        withCompletionHandler completionHandler: @escaping () -> Void
    ) {

    }

    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        openSettingsFor notification: UNNotification?
    ) {

    }
}

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
