//
//  PlanDurationCreatePlanViewController.swift
//  Rise
//
//  Created by Владимир Королев on 03.01.2020.
//  Copyright © 2020 VladimirBrejcha. All rights reserved.
//

import UIKit

final class PlanDurationCreatePlanViewController: UIViewController {

    var planDurationOutput: ((Int) -> Void)!
    
    @IBOutlet weak var planDurationLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    @IBAction private func planDurationChanged(_ sender: UISlider) {
        let value = Int(sender.value)
        
        switch value {
        case Int.min...20:
            planDurationLabel.text = "\(value) days (hardcore)"
        case 20...40:
            planDurationLabel.text = "\(value) days (recommented)"
        case 40...Int.max:
            planDurationLabel.text = "\(value) days (peacefully)"
        default: break
        }
        planDurationOutput(value)
    }
}
