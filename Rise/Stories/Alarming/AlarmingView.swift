//
//  AlarmingView.swift
//  Rise
//
//  Created by Владимир Королев on 08.01.2021.
//  Copyright © 2021 VladimirBrejcha. All rights reserved.
//

import UIKit

final class AlarmingView: UIView, BackgroundSettable {
    @IBOutlet private var currentTimeLabel: AutoRefreshableLabel!
    @IBOutlet private weak var greetLabel: UILabel!
    @IBOutlet private var stopAlarmButton: LongPressProgressButton!
    @IBOutlet private var snoozeButton: Button!

    func configure(
        timeDataSource: @escaping () -> String,
        didSnooze: @escaping () -> Void,
        didStop: @escaping () -> Void
    ) {
        snoozeButton.setTitle("Snooze", for: .normal)
        snoozeButton.touchDownObserver = { _ in didSnooze() }

        stopAlarmButton.title = "Stop alarm"
        stopAlarmButton.progressCompleted = { _ in didStop() }
        
        greetLabel.text = "Wake and Rise!"

        currentTimeLabel.dataSource = timeDataSource
        currentTimeLabel.beginRefreshing()
    }
}
