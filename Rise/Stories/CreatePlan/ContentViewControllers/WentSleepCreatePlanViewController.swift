//
//  WentSleepCreatePlanViewController.swift
//  Rise
//
//  Created by Владимир Королев on 03.01.2020.
//  Copyright © 2020 VladimirBrejcha. All rights reserved.
//

import UIKit

final class WentSleepCreatePlanViewController: UIViewController {
    
    var wentSleepTimeOutput: ((Date) -> Void)!

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction private func wentSleepTimeChanged(_ sender: UIDatePicker) {
        wentSleepTimeOutput(sender.date)
    }
}
