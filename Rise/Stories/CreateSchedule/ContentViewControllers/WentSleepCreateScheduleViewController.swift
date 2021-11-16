//
//  WentSleepCreateScheduleViewController.swift
//  Rise
//
//  Created by Vladimir Korolev on 03.01.2020.
//  Copyright © 2020 VladimirBrejcha. All rights reserved.
//

import UIKit

final class WentSleepCreateScheduleViewController: UIViewController {
    @IBOutlet private weak var wentSleepDatePicker: UIDatePicker!
    
    var wentSleepTimeOutput: ((Date) -> Void)? // DI
    var currentWentSleepTime: (() -> Date?)? // DI
    
    override func viewDidLoad() {
        super.viewDidLoad()

        wentSleepDatePicker.applyStyle(.usual)
        if let currentWentSleepTime = currentWentSleepTime?() {
            wentSleepDatePicker.setDate(currentWentSleepTime, animated: false)
        }
    }
    
    @IBAction private func wentSleepTimeChanged(_ sender: UIDatePicker) {
        wentSleepTimeOutput?(sender.date)
    }
}
