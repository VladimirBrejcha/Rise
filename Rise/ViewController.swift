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
        
    }
    
}

