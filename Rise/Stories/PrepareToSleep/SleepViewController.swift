//
//  ViewController.swift
//  Rise
//
//  Created by Vladimir Korolev on 23/05/2019.
//  Copyright © 2019 VladimirBrejcha. All rights reserved.
//

import UIKit
import UserNotifications

final class SleepViewController: UIViewController {
    
    // MARK: Properties
    private let textColor = "textColor"
    
    // MARK: IBOutlets
    @IBOutlet weak var sleepButton: UIButton!
    @IBOutlet weak var timePicker: UIDatePicker!
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTimePicker()
        registerLocal()
        createBackground()
    }
    
    // MARK: UI setup methods
    private func setupTimePicker() {
        timePicker.setValue(UIColor.white, forKeyPath: textColor)
    }
    
    private func createBackground() {
        let backgroundView = GradientHelper.makeDefaultStaticGradient(for: view.bounds)
        view.addSubview(backgroundView)
        view.sendSubviewToBack(backgroundView)
    }
    
    // MARK: Notification center methods
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
        content.userInfo = ["customData": "fizzbuzz"]
        content.sound = .default
        
        let date = timePicker.date
        
        let components = calendar.dateComponents([.hour, .minute], from: date)
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        center.add(request)
        
    }
    
    // MARK: IBActions
    @IBAction func sleepButtonPressed(_ sender: UIButton) {
        scheduleLocal()
    }
    
}
