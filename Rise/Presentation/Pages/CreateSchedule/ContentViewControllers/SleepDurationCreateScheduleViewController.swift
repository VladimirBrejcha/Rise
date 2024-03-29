//
//  SleepDurationCreateScheduleViewController.swift
//  Rise
//
//  Created by Vladimir Korolev on 03.01.2020.
//  Copyright © 2020 VladimirBrejcha. All rights reserved.
//

import UIKit

final class SleepDurationCreateScheduleViewController: UIViewController {

    @IBOutlet private weak var sleepDurationLabel: UILabel!
    @IBOutlet private weak var sleepDurationSlider: UISlider!

    @IBOutlet private var icon: UIImageView!

    private let minimumDurationH = 6
    private let maximumDurationH = 10
    private let recommendedDurationH = 8

    var sleepDurationOutput: ((Int) -> Void)? // DI
    var currentSleepDuration: (() -> Int?)? // DI

    override func viewDidLoad() {
        super.viewDidLoad()

        sleepDurationSlider.minimumValue = Float(minimumDurationH * 60)
        sleepDurationSlider.maximumValue = Float(maximumDurationH * 60)
        if let currentSleepDuration = currentSleepDuration?() {
            sleepDurationSlider.value = Float(currentSleepDuration)
            sleepDurationLabel.text = currentSleepDuration.HHmmString
        } else {
            sleepDurationSlider.value = Float(recommendedDurationH * 60)
        }
        icon.layer.applyStyle(.gloomingIcon)
    }

    @IBAction private func sleepDurationChanged(_ sender: UISlider) {
        let chosenDuration = Int(sender.value)
        sleepDurationLabel.text = chosenDuration.HHmmString
        sleepDurationOutput?(chosenDuration)
    }
}
