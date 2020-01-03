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
    @IBOutlet weak var sleepDurationSlider: UISlider!
    
    private let minimumDurationH = 6
    private let maximumDurationH = 10
    private let recomendedDurationH = 8
    
    var sleepDurationOutput: ((Int) -> Void)!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sleepDurationSlider.minimumValue = Float(minimumDurationH * 60)
        sleepDurationSlider.maximumValue = Float(maximumDurationH * 60)
        sleepDurationSlider.value = Float(recomendedDurationH * 60)
    }
    
    @IBAction func sleepDurationChanged(_ sender: UISlider) {
        let chosenDuration = Int(sender.value)
        let hours = chosenDuration / 60
        let minutes = chosenDuration % 60
        
        sleepDurationLabel.text = minutes == 0
            ? "\(hours) hours"
            : "\(hours) h \(minutes) m"
        
        sleepDurationOutput(chosenDuration)
    }
}
