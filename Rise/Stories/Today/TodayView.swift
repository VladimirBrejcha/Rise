//
//  TodayView.swift
//  Rise
//
//  Created by Владимир Королев on 01.08.2020.
//  Copyright © 2020 VladimirBrejcha. All rights reserved.
//

import UIKit

final class TodayView: UIView {
    @IBOutlet private var sleepButton: Button!
    @IBOutlet private weak var timeUntilSleep: FloatingLabel!

    func configure(
        timeUntilSleepDataSource: @escaping () -> FloatingLabel.Model,
        sleepHandler: @escaping () -> Void
    ) {
        sleepButton.onTouchUp = { _ in sleepHandler() }
        timeUntilSleep.dataSource = timeUntilSleepDataSource
        timeUntilSleep.font = Styles.Label.Notification.font
        timeUntilSleep.beginRefreshing()
    }
}
