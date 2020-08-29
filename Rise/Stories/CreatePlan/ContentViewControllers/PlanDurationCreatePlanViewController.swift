//
//  PlanDurationCreatePlanViewController.swift
//  Rise
//
//  Created by Владимир Королев on 03.01.2020.
//  Copyright © 2020 VladimirBrejcha. All rights reserved.
//

import UIKit

final class PlanDurationCreatePlanViewController: UIViewController {
    @IBOutlet private weak var planDurationSlider: UISlider!
    @IBOutlet private weak var planDurationLabel: UILabel!
    
    var planDurationOutput: ((Int) -> Void)! // DI
    var presettedPlanDuration: Int? // DI
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let presettedPlanDuration = presettedPlanDuration {
            planDurationSlider.setValue(Float(presettedPlanDuration), animated: false)
            updatePlanDurationlabel(with: presettedPlanDuration)
        }
    }

    @IBAction private func planDurationChanged(_ sender: UISlider) {
        let value = Int(sender.value)
        updatePlanDurationlabel(with: value)
        planDurationOutput(value)
    }
    
    private func updatePlanDurationlabel(with days: Int) {
        switch days {
        case Int.min...20:
            planDurationLabel.text = "\(days) days (hardcore)"
        case 20...40:
            planDurationLabel.text = "\(days) days (recommented)"
        case 40...Int.max:
            planDurationLabel.text = "\(days) days (peacefully)"
        default: break
        }
    }
}
