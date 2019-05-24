//
//  ViewController.swift
//  Rise
//
//  Created by Vladimir Korolev on 23/05/2019.
//  Copyright © 2019 VladimirBrejcha. All rights reserved.
//

import UIKit
import UserNotifications

class ViewController: UIViewController {
    
    @IBOutlet weak var sleepButton: UIButton!
    @IBOutlet weak var timePicker: UIDatePicker!
    
  
    //VC life cycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTimePicker()
        registerLocal()
        scheduleLocal()
    }
    
    //UI setup methods
    private func setupTimePicker() {
        timePicker.setValue(UIColor.white, forKeyPath: "textColor")
    }
    
    //Notification center methods
    private func registerLocal() {
        let center = UNUserNotificationCenter.current()
        
        center.requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
            if granted {
                print("granted")
            } else {
                print("\(String(describing: error))")
            }
        }
    }
    
    private func scheduleLocal() {
        let center = UNUserNotificationCenter.current()
        center.removeAllPendingNotificationRequests()
        
        let content = UNMutableNotificationContent()
        
        content.title = "Wake up"
        content.body = "its time to rise and shine"
        content.categoryIdentifier = "alarm"
        content.userInfo = ["customData" : "fizzbuzz"]
        content.sound = .default
        
//        var dateComponents = DateComponents()
//        dateComponents.hour = 10
//        dateComponents.minute = 30
//        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        center.add(request)
        
    }
    
}

