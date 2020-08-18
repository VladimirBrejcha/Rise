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
        
    struct Model {
        let stopTitle: String
        let alarmTime: String
    }
    var model: Model? {
        didSet {
            if let model = model {
                stopButton.title = model.stopTitle
                alarmLabel.text = model.alarmTime
            }
        }
    }
    
    struct DataSource {
        let timeLeft: () -> FloatingLabel.Model
        let currentTime: () -> String
    }
    
    func configure(model: Model, dataSource: DataSource, stopHandler: @escaping () -> Void) {
        self.model = model
        stopButton.progressCompleted = { _ in stopHandler() }
        timeLeftLabel.dataSource = dataSource.timeLeft
        currentTimeLabel.dataSource = dataSource.currentTime
    }
}
