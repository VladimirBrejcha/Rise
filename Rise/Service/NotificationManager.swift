//
//  NotificationManager.swift
//  Rise
//
//  Created by Vladimir Korolev on 08.01.2021.
//  Copyright © 2021 VladimirBrejcha. All rights reserved.
//

import UserNotifications
import Core

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
//MARK: - Request permission

func registerLocal() {
    let notificationCenter = UNUserNotificationCenter.current()
    
        notificationCenter.requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
            guard granted else { return }
                notificationCenter.getNotificationSettings { (settings)  in
                    print("Notification settings: \(settings)")
                    guard settings.authorizationStatus == .authorized else { return }
        }
    }
}
//MARK: - Notifications
func notifyIsTimeToSleep () {
    let center = UNUserNotificationCenter.current()
    
    let content = UNMutableNotificationContent()
    content.title = "Is time to sleep"
    content.body = "if you're in the rhythm you need to go to sleep"
    content.categoryIdentifier = "notify to sleep"
    content.sound = .default
    
    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
    let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
    center.add(request)
}


//

protocol Notification {
    
}

let notificationTitles: [String] = ["Sleepy Time Awaits",
                                    "Ready for Dreamland?",
                                    "Dream Journey Ahead",
                                    "Time to Recharge",
                                    "Off to the Land of Nod",
                                    "Embrace the Night",
                                    "Your Dreams Await",
                                    "Healing Slumber Calls",
                                    "Step into Tranquility",
                                    "Unleash Your Rest"]

let notificationDescriptions: [String] = ["Sleep is the best meditation. Are you ready to recharge for a better tomorrow?",
                                          "Don't count sheep, count on us for a better sleep. Shall we begin?",
                                          "Your dreams are waiting for you. Ready to explore them with us?",
                                          "The stars are shining, and the moon is bright. It's the perfect time to say goodnight. Shall we?",
                                          "Empower your tomorrow with the sleep of today. Ready to rest your mind?",
                                          "Your body heals during sleep. Let's get some healing done, shall we?",
                                          "Sweet dreams are made of these moments of peace. Ready to dive into tranquility?",
                                          "Tonight's forecast? 100% chance of sleep. Ready for a blissful journey?",
                                          "A well-rested you is the best you. Are you ready to wake up refreshed?",
                                          "The night is young, and dreams are waiting. Ready to join the world of dreams?"]

let cancelButtons: [String] = ["Maybe Later",
                               "Not Now",
                               "Perhaps Later",
                               "Maybe in a Bit",
                               "Later",
                               "Not Yet",
                               "Later Maybe",
                               "Soon",
                               "In a While",
                               "A Bit Later"]

let acceptButtons: [String] = ["Start Sleeping",
                               "Yes, Let's Sleep",
                               "Begin Dreaming",
                               "Goodnight",
                               "Start Resting",
                               "Time to Heal",
                               "Dive In",
                               "Start Journey",
                               "Refresh Now",
                               "Join Dreams"]
