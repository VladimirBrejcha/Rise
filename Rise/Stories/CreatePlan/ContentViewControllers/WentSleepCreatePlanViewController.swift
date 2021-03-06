//
//  WentSleepCreatePlanViewController.swift
//  Rise
//
//  Created by Владимир Королев on 03.01.2020.
//  Copyright © 2020 VladimirBrejcha. All rights reserved.
//

import UIKit

final class WentSleepCreatePlanViewController: UIViewController {
    @IBOutlet private weak var wentSleepDatePicker: UIDatePicker!
    
    var wentSleepTimeOutput: ((Date) -> Void)! // DI
    var presettedWentSleepTime: Date? // DI
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        wentSleepDatePicker.setValue(UIColor.white, forKeyPath: "textColor")
        if let presettedWentSleepTime = presettedWentSleepTime {
            wentSleepDatePicker.setDate(presettedWentSleepTime, animated: false)
        }
    }
    
    @IBAction private func wentSleepTimeChanged(_ sender: UIDatePicker) {
        wentSleepTimeOutput(sender.date)
    }
}
