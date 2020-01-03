//
//  CreatePlanFirstContentViewController.swift
//  Rise
//
//  Created by Владимир Королев on 11.12.2019.
//  Copyright © 2019 VladimirBrejcha. All rights reserved.
//

import UIKit

final class WakeUpTimeSetupPlanViewController: UIViewController {
    
    var wakeUpTimeOutput: ((Date) -> Void)!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func wakeUpTimeChanged(_ sender: UIDatePicker) {
        wakeUpTimeOutput(sender.date)
    }
}
