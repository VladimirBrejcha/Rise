//
//  SleepDurationSetupPlanViewController.swift
//  Rise
//
//  Created by Владимир Королев on 03.01.2020.
//  Copyright © 2020 VladimirBrejcha. All rights reserved.
//

import UIKit

final class SleepDurationSetupPlanViewController: UIViewController {

    @IBOutlet weak var sleepDurationLabel: UILabel!
    
    private let minimumDurationH = 6
    private let maximumDurationH = 10
    private let recomendedDurationN = 8
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func sleepDurationChanged(_ sender: UISlider) {
        let chosenDuration = Int(sender.value)
        let hours = chosenDuration / 60
        let minutes = chosenDuration % 60
        
        sleepDurationLabel.text = minutes == 0
            ? "\(hours) hours"
            : "\(hours) h \(minutes) m"
    }
}
