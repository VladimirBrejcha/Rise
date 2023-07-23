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
    
    @IBOutlet private var icon: UIImageView!

    var wentSleepTimeOutput: ((Date) -> Void)? // DI
    var currentWentSleepTime: (() -> Date?)? // DI
    
    override func viewDidLoad() {
        super.viewDidLoad()

        wentSleepDatePicker.applyStyle(.usual)
        if let currentWentSleepTime = currentWentSleepTime?() {
            wentSleepDatePicker.setDate(currentWentSleepTime, animated: false)
        }
        icon.layer.applyStyle(.gloomingIcon)
    }
    
    @IBAction private func wentSleepTimeChanged(_ sender: UIDatePicker) {
        wentSleepTimeOutput?(sender.date)
    }
}
