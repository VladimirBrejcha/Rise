//
//  SleepDurationCreatePlanViewController.swift
//  Rise
//
//  Created by Владимир Королев on 03.01.2020.
//  Copyright © 2020 VladimirBrejcha. All rights reserved.
//

import UIKit

final class SleepDurationCreatePlanViewController: UIViewController {
    @IBOutlet private weak var sleepDurationLabel: UILabel!
    @IBOutlet private weak var sleepDurationSlider: UISlider!
    
    private let minimumDurationH = 6
    private let maximumDurationH = 10
    private let recomendedDurationH = 8
    
    var sleepDurationOutput: ((Int) -> Void)! // DI
    var presettedSleepDuration: Int? // DI
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sleepDurationSlider.minimumValue = Float(minimumDurationH * 60)
        sleepDurationSlider.maximumValue = Float(maximumDurationH * 60)
        if let presettedSleepDuration = presettedSleepDuration {
            sleepDurationSlider.value = Float(presettedSleepDuration)
            sleepDurationLabel.text = presettedSleepDuration.HHmmString
        } else {
            sleepDurationSlider.value = Float(recomendedDurationH * 60)
        }
    }
    
    @IBAction private func sleepDurationChanged(_ sender: UISlider) {
        let chosenDuration = Int(sender.value)
        sleepDurationLabel.text = chosenDuration.HHmmString
        sleepDurationOutput(chosenDuration)
    }
}
