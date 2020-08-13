//
//  SleepView.swift
//  Rise
//
//  Created by Владимир Королев on 13.08.2020.
//  Copyright © 2020 VladimirBrejcha. All rights reserved.
//

import UIKit

final class SleepView: UIView, BackgroundSettable {
    @IBOutlet private weak var currentTimeLabel: AutoRefreshableLabel!
    @IBOutlet private weak var alarmLabel: UILabel!
    @IBOutlet private weak var stopButton: LongPressProgressButton!
    @IBOutlet private weak var timeLeftLabel: FloatingLabel!
    
    var model: Model! {
        didSet {
            stopButton.title = model.stopTitle
            stopButton.progressCompleted = model.stopPressHandler
            alarmLabel.text = model.alarmTime
            currentTimeLabel.dataSource = model.currentTimeDataSource
            timeLeftLabel.dataSource = model.timeLeftDataSource
        }
    }
    
    struct Model {
        var stopTitle: String
        var alarmTime: String
        var stopPressHandler: (LongPressProgressButton) -> Void
        var currentTimeDataSource: () -> String
        var timeLeftDataSource: () -> FloatingLabel.Model
    }
}
