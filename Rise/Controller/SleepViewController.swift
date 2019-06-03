//
//  ViewController.swift
//  Rise
//
//  Created by Vladimir Korolev on 23/05/2019.
//  Copyright © 2019 VladimirBrejcha. All rights reserved.
//

import UIKit
import UserNotifications
import SPStorkController
import Dodo

class SleepViewController: UIViewController {

    @IBOutlet weak var sleepButton: UIButton!
    @IBOutlet weak var timePicker: UIDatePicker!

    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTimePicker()
        registerLocal()
        setupDodoBar()
        
    }
    
    // MARK: UI setup methods
    private func setupTimePicker() {
        timePicker.setValue(UIColor.white, forKeyPath: Constants.KeyPath.textColor)
    }
    
    private func setupDodoBar() {
        view.dodo.style.bar.cornerRadius = 12
        view.dodo.style.bar.hideAfterDelaySeconds = 3
        view.dodo.style.bar.backgroundColor = #colorLiteral(red: 0.262835294, green: 0.8022480607, blue: 0.3886030316, alpha: 0.6978983275)
        
        view.dodo.style.bar.animationShow = DodoAnimations.fade.show
        view.dodo.style.bar.animationHide = DodoAnimations.fade.hide
        
        view.dodo.topAnchor = view.safeAreaLayoutGuide.topAnchor
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
    
    @IBAction func bottomButton(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: Constants.Storyboard.name, bundle: nil)
        
        let controller = storyboard.instantiateViewController(withIdentifier: Constants.Controllers.Identifiers.personal)
        
        let transitionDelegate = SPStorkTransitioningDelegate()
        
        controller.transitioningDelegate = transitionDelegate
        controller.modalPresentationStyle = .custom
        controller.modalPresentationCapturesStatusBarAppearance = true
        
        transitionDelegate.storkDelegate = self
        
        self.present(controller, animated: true, completion: nil)
    }
    
}

extension SleepViewController: SPStorkControllerDelegate {
    
    func didDismissStorkBySwipe() {
        view.dodo.success("Saved!")
    }
}
