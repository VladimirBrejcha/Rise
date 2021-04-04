//
//  PrepareToSleepView.swift
//  Rise
//
//  Created by Владимир Королев on 13.08.2020.
//  Copyright © 2020 VladimirBrejcha. All rights reserved.
//

import UIKit

final class PrepareToSleepView: UIView, PropertyAnimatable {
    // MARK: - PropertyAnimatable
    var propertyAnimationDuration: Double = 0.3
    
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var startSleepButton: FloatingButton!
    @IBOutlet private weak var startSleepLabel: UILabel!
    @IBOutlet private weak var wakeUpContainerHeightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var wakeUpTitleLabel: UILabel!
    @IBOutlet private weak var wakeUpDatePicker: UIDatePicker!
    @IBOutlet private weak var timeUntilWakeUpLabel: AutoRefreshableLabel!
    @IBOutlet private weak var toSleepLabel: UILabel!
    
    // MARK: - State
    enum State: Equatable {
        case normal
        case expanded
    }
    var state: State = .normal {
        didSet {
            animate { [weak self] in
                if let self = self {
                    self.toSleepLabel.alpha = self.state == .expanded ? 0 : 1
                    self.wakeUpContainerHeightConstraint.constant = self.state == .expanded ? 200 : 50
                    self.layoutIfNeeded()
                }
            }
        }
    }
    
    // MARK: - Model
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
    
    struct DataSource {
        let timeUntilWakeUp: () -> String
    }
    
    // MARK: - Handlers
    struct Handlers {
        let wakeUp: () -> Void
        let sleep: () -> Void
        let close: () -> Void
        let wakeUpTimeChanged: (Date) -> Void
    }
    private var handlers: Handlers?
    
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
    
    // MARK: - Configure
    private var isConfigured = false
    func configure(model: Model, dataSource: DataSource, handlers: Handlers) {
        if isConfigured { return }
        
        self.model = model
        self.handlers = handlers
        timeUntilWakeUpLabel.dataSource = dataSource.timeUntilWakeUp
        timeUntilWakeUpLabel.beginRefreshing()

        startSleepButton.backgroundColor = .clear
        startSleepButton.alpha = 0.9
        
        isConfigured = true
    }
}

extension PrepareToSleepView.Model: Changeable {
    init(copy: ChangeableWrapper<PrepareToSleepView.Model>) {
        self.init(
            toSleepText: copy.toSleepText,
            title: copy.title,
            startSleepText: copy.startSleepText,
            wakeUpTitle: copy.wakeUpTitle,
            wakeUpTime: copy.wakeUpTime
        )
    }
}
