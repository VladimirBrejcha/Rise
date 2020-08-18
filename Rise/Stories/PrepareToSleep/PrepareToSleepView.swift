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
    
    // MARK: - PropertyAnimatable
    var propertyAnimationDuration: Double = 0.3
    
    enum State: Equatable {
        case normal
        case expanded
    }
    var state: State = .normal {
        didSet {
            expand(state == .expanded)
        }
    }
    
    struct Model {
        let toSleepText: String
        let title: String
        let startSleepText: String
        let wakeUpTitle: String
        let wakeUpTime: Date
    }
    var model: Model? {
        didSet {
            if let model = model {
                toSleepLabel.text = model.toSleepText
                titleLabel.text = model.title
                startSleepLabel.text = model.startSleepText
                wakeUpTitleLabel.text = model.wakeUpTitle
                wakeUpDatePicker.date = model.wakeUpTime
            }
        }
    }
    
    struct Handlers {
        let wakeUp: () -> Void
        let sleep: () -> Void
        let close: () -> Void
        let wakeUpTimeChanged: (Date) -> Void
    }
    var handlers: Handlers?
    
    struct DataSource {
        let timeUntilWakeUp: () -> String
    }
    
    func configure(model: Model, dataSource: DataSource, handlers: Handlers) {
        self.model = model
        self.handlers = handlers
        timeUntilWakeUpLabel.dataSource = dataSource.timeUntilWakeUp
        initialSetup()
    }
    
    @IBAction private func startSleepTouchUp(_ sender: FloatingButton) {
        handlers?.sleep()
    }
    
    @IBAction private func closeTouchUp(_ sender: UIButton) {
        handlers?.close()
    }
    
    @IBAction private func wakeUpValueChanged(_ sender: UIDatePicker) {
        handlers?.wakeUpTimeChanged(sender.date)
    }
    
    @IBAction private func wakeUpTouchUp(_ sender: UITapGestureRecognizer) {
        handlers?.wakeUp()
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
