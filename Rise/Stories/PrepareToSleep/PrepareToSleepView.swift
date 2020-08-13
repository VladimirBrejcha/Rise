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
        let wakeUpValueChangedHandler: (Date) -> Void
    }
    
    // MARK: -  PropertyAnimatable
    var propertyAnimationDuration: Double = 0.3
    
    var state: State = .normal {
        didSet {
            expand(state == .expanded)
        }
    }
    
    var model: Model? {
        didSet {
            initialSetup()
            if let model = model {
                toSleepLabel.text = model.toSleepText
                titleLabel.text = model.title
                timeUntilWakeUpLabel.dataSource = model.timeUntilWakeUpDataSource
                startSleepLabel.text = model.startSleepText
                wakeUpTitleLabel.text = model.wakeUpTitle
                wakeUpDatePicker.date = model.wakeUpTime
            }
        }
    }
    
    @IBAction private func startSleepTouchUp(_ sender: FloatingButton) {
        model?.startSleepHandler()
    }
    
    @IBAction private func closeTouchUp(_ sender: UIButton) {
        model?.closeHandler()
    }
    
    @IBAction private func wakeUpValueChanged(_ sender: UIDatePicker) {
        model?.wakeUpValueChangedHandler(sender.date)
    }
    
    @IBAction private func wakeUpTouchUp(_ sender: UITapGestureRecognizer) {
        model?.wakeUpTouchHandler()
    }
    
    // MARK: - Private
    private var needSetup = true
    private func initialSetup() {
        if needSetup {
            startSleepButton.layer.cornerRadius = 0
            startSleepButton.backgroundColor = .clear
            startSleepButton.alpha = 0.9
            timeUntilWakeUpLabel.beginRefreshing()
            needSetup = false
        }
    }
    
    private func expand(_ expand: Bool) {
        animate {
            self.wakeUpContainerheightConstraint.constant = expand ? 200 : 50
            self.layoutIfNeeded()
        }
    }
}
