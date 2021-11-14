//
//  WakeUpTimeCreateScheduleViewController.swift
//  Rise
//
//  Created by Vladimir Korolev on 11.12.2019.
//  Copyright © 2019-2020 VladimirBrejcha. All rights reserved.
//

import UIKit

final class WakeUpTimeCreateScheduleViewController: UIViewController {
    @IBOutlet private weak var wakeUpTimeDatePicker: UIDatePicker!
    
    var wakeUpTimeOutput: ((Date) -> Void)! // DI
    var presettedWakeUpTime: Date? // DI
    
    override func viewDidLoad() {
        super.viewDidLoad()

        wakeUpTimeDatePicker.applyStyle(.usual)
        if let presettedWakeUpTime = presettedWakeUpTime {
            wakeUpTimeDatePicker.setDate(presettedWakeUpTime, animated: false)
        }
    }
    
    @IBAction private func wakeUpTimeChanged(_ sender: UIDatePicker) {
        wakeUpTimeOutput(sender.date)
    }
}
