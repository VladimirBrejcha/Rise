//
//  PrepareToSleepView.swift
//  Rise
//
//  Created by Владимир Королев on 13.08.2020.
//  Copyright © 2020 VladimirBrejcha. All rights reserved.
//

import UIKit

final class PrepareToSleepView: UIView, BackgroundSettable, PropertyAnimatable {
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var startSleepButton: FloatingButton!
    @IBOutlet private weak var startSleepLabel: UILabel!
    @IBOutlet private weak var wakeUpContainerheightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var wakeUpTitleLabel: UILabel!
    @IBOutlet private weak var wakeUpDatePicker: UIDatePicker!
    @IBOutlet private weak var timeUntilWakeUpLabel: AutoRefreshableLabel!
    @IBOutlet private weak var toSleepLabel: UILabel!
    
    enum State: Equatable {
        case normal
        case expanded
    }
    
    struct Model {
        let toSleepText: String
        let title: String
        let timeUntilWakeUpDataSource: () -> String
        let startSleepText: String
        let wakeUpTitle: String
        let wakeUpTime: Date
        let wakeUpTouchHandler: () -> Void
        let startSleepHandler: () -> Void
        let closeHandler: () -> Void
        let pickerValueChangeHandler: (Date) -> Void
    }
    
    // MARK: -  PropertyAnimatable
    var propertyAnimationDuration: Double = 0.3
    
    var state: State = .normal {
        didSet {
            expand(state == .expanded)
        }
    }
    
    var model: Model! {
        didSet {
            initialSetup()
            toSleepLabel.text = model.toSleepText
            titleLabel.text = model.title
            timeUntilWakeUpLabel.dataSource = model.timeUntilWakeUpDataSource
            startSleepLabel.text = model.startSleepText
        }
    }
    
    private func initialSetup() {
        startSleepButton.layer.cornerRadius = 0
        startSleepButton.backgroundColor = .clear
        startSleepButton.alpha = 0.9
        timeUntilWakeUpLabel.beginRefreshing()
    }
    
    private func expand(_ expand: Bool) {
        animate {
            self.wakeUpContainerheightConstraint.constant = expand ? 200 : 50
            self.layoutIfNeeded()
        }
    }
}

extension PrepareToSleepView.Model: Changeable {
    init(copy: ChangeableWrapper<PrepareToSleepView.Model>) {
        self.init(
            toSleepText: copy.toSleepText,
            title: copy.title,
            timeUntilWakeUpDataSource: copy.timeUntilWakeUpDataSource,
            startSleepText: copy.startSleepText,
            wakeUpTitle: copy.wakeUpTitle,
            wakeUpTime: copy.wakeUpTime,
            wakeUpTouchHandler: copy.wakeUpTouchHandler,
            startSleepHandler: copy.startSleepHandler,
            closeHandler: copy.closeHandler,
            pickerValueChangeHandler: copy.pickerValueChangeHandler
        )
    }
}
