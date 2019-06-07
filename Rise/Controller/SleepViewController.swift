//
//  ViewController.swift
//  Rise
//
//  Created by Vladimir Korolev on 23/05/2019.
//  Copyright © 2019 VladimirBrejcha. All rights reserved.
//

import UIKit
import UserNotifications
import AnimatedGradientView

class SleepViewController: UIViewController {

    @IBOutlet weak var sleepButton: UIButton!
    @IBOutlet weak var timePicker: UIDatePicker!

    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTimePicker()
        registerLocal()
        
        let gradientView = AnimatedGradientView(frame: view.bounds)
        gradientView.colors = [[#colorLiteral(red: 0.0862745098, green: 0.07450980392, blue: 0.1568627451, alpha: 1), #colorLiteral(red: 0.4588235294, green: 0.168627451, blue: 0.2705882353, alpha: 1)]]
        gradientView.direction = .up
        gradientView.alpha = 0.5
        view.addSubview(gradientView)
        view.sendSubviewToBack(gradientView)
    }

    // MARK: UI setup methods
    private func setupTimePicker() {
        timePicker.setValue(UIColor.white, forKeyPath: Constants.KeyPath.textColor)
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

        let components = Calendar.current.dateComponents([.hour, .minute], from: date)

        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)

        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        center.add(request)

    }
    
    // MARK: IBActions
    @IBAction func sleepButtonPressed(_ sender: UIButton) {
        scheduleLocal()
    }
    
}
