//
//  WakeUpTimeCreateScheduleViewController.swift
//  Rise
//
//  Created by Vladimir Korolev on 11.12.2019.
//  Copyright © 2019-2020 VladimirBrejcha. All rights reserved.
//

import UIKit

final class WakeUpTimeCreateScheduleViewController: UIViewController {
    @IBOutlet private var wakeUpTimeDatePicker: UIDatePicker!
    @IBOutlet private var expectedToBedLabel: UILabel!

    var wakeUpTimeOutput: ((Date) -> Void)? // DI
    var toBedTimeOutput: ((Date) -> Void)? // DI
    var currentWakeUpTime: (() -> Date?)? // DI
    var currentSleepDuration: (() -> Int?)? // DI

    override func viewDidLoad() {
        super.viewDidLoad()

        wakeUpTimeDatePicker.applyStyle(.usual)

        if let currentWakeUpTime = currentWakeUpTime?() {
            wakeUpTimeDatePicker.setDate(currentWakeUpTime, animated: false)
        }
        if let currentSleepDuration = currentSleepDuration?() {
            let toBedTime = makeExpectedToBedTime(
                from: wakeUpTimeDatePicker.date,
                sleepDuration: currentSleepDuration
            )
            refreshToBedLabel(text: makeToBedText(date: toBedTime))
        }
    }

    @IBAction private func wakeUpTimeChanged(_ sender: UIDatePicker) {
        guard let currentSleepDuration = currentSleepDuration?() else { return }
        let toBedTime = makeExpectedToBedTime(
            from: sender.date,
            sleepDuration: currentSleepDuration
        )
        toBedTimeOutput?(toBedTime)
        refreshToBedLabel(text: makeToBedText(date: toBedTime))
        wakeUpTimeOutput?(sender.date)
    }

    private func refreshToBedLabel(text: String) {
        expectedToBedLabel.text = text
    }

    private func makeExpectedToBedTime(
        from wakeUpDate: Date,
        sleepDuration: Int
    ) -> Date {
        wakeUpDate.addingTimeInterval(minutes: -sleepDuration)
    }

    private func makeToBedText(date: Date) -> String {
        "To sleep at \(date.HHmmString) o'clock"
    }
}
