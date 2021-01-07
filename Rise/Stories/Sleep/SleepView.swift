//
//  SleepView.swift
//  Rise
//
//  Created by Владимир Королев on 13.08.2020.
//  Copyright © 2020 VladimirBrejcha. All rights reserved.
//

import UIKit

final class SleepView: UIView, BackgroundSettable, PropertyAnimatable {
    @IBOutlet private weak var currentTimeLabel: AutoRefreshableLabel!
    @IBOutlet private weak var stopButton: LongPressProgressButton!
    @IBOutlet private weak var timeLeftLabel: FloatingLabel!
    @IBOutlet private weak var editAlarmButton: UIButton!
    @IBOutlet private weak var editAlarmDatePicker: UIDatePicker!
    @IBOutlet private weak var cancelEditAlarmButton: UIButton!
    @IBOutlet private weak var saveAlarmEditButton: UIButton!
    @IBOutlet private weak var editAlarmButtonContainer: DesignableContainerView!

    // MARK: - PropertyAnimatable
    var propertyAnimationDuration: Double { 0.15 }

    private var editAlarmHandler: (() -> Void)?
    private var cancelAlarmEditHandler: (() -> Void)?
    private var saveAlarmEditHandler: (() -> Void)?
    private var alarmTimeChangedHandler: ((Date) -> Void)?

    private let defaultControlAlpha: CGFloat = 0.9

    enum State {
        case normal
        case editingAlarm
    }

    struct Model {
        let state: State
        let alarm: Date
    }

    var model: Model? {
        didSet {
            guard let model = model else { return }
            animate { [weak self] in
                guard let self = self else { return }
                switch model.state {
                case .normal:
                    self.editAlarmButtonContainer.alpha = self.defaultControlAlpha
                    self.editAlarmButton.alpha = self.defaultControlAlpha
                    self.cancelEditAlarmButton.alpha = 0
                    self.saveAlarmEditButton.alpha = 0
                    self.editAlarmDatePicker.alpha = 0
                    self.editAlarmButton.setTitle(model.alarm.HHmmString, for: .normal)
                case .editingAlarm:
                    self.editAlarmButtonContainer.alpha = 0
                    self.editAlarmButton.alpha = 0
                    self.cancelEditAlarmButton.alpha = self.defaultControlAlpha
                    self.saveAlarmEditButton.alpha = self.defaultControlAlpha
                    self.editAlarmDatePicker.alpha = self.defaultControlAlpha
                    self.editAlarmDatePicker.date = model.alarm
                }
            }
        }
    }

    struct DataSource {
        let timeLeft: () -> FloatingLabel.Model
        let currentTime: () -> String
    }
    
    func configure(
        initialModel model: Model,
        dataSource: DataSource,
        editAlarmHandler: @escaping () -> Void,
        cancelAlarmEditHandler: @escaping () -> Void,
        saveAlarmEditHandler: @escaping () -> Void,
        alarmTimeChangedHandler: @escaping (Date) -> Void,
        stopHandler: @escaping () -> Void
    ) {
        editAlarmButton.setImage(UIImage(systemName: "bell.fill"), for: .normal)
        editAlarmButton.centerTextAndImage(spacing: 8)
        editAlarmButton.tintColor = Color.normalTitle
        editAlarmButton.titleLabel?.font = .systemFont(ofSize: 24)

        stopButton.title = "Stop"
        stopButton.progressCompleted = { _ in stopHandler() }

        editAlarmDatePicker.datePickerMode = .time
        if #available(iOS 14.0, *) {
            editAlarmDatePicker.preferredDatePickerStyle = .inline
        } else {
            editAlarmDatePicker.preferredDatePickerStyle = .compact
        }

        timeLeftLabel.dataSource = dataSource.timeLeft
        timeLeftLabel.beginRefreshing()

        currentTimeLabel.dataSource = dataSource.currentTime
        currentTimeLabel.beginRefreshing()

        self.model = model

        self.editAlarmHandler = editAlarmHandler
        self.cancelAlarmEditHandler = cancelAlarmEditHandler
        self.saveAlarmEditHandler = saveAlarmEditHandler
        self.alarmTimeChangedHandler = alarmTimeChangedHandler
    }

    @IBAction private func alarmTouchUp(_ sender: UIButton) {
        editAlarmHandler?()
    }

    @IBAction private func alarmValueChanged(_ sender: UIDatePicker) {
        alarmTimeChangedHandler?(sender.date)
    }

    @IBAction private func cancelAlarmEditTouchUp(_ sender: UIButton) {
        cancelAlarmEditHandler?()
    }

    @IBAction private func saveAlarmEditTouchUp(_ sender: UIButton) {
        saveAlarmEditHandler?()
    }
}

extension SleepView.Model: Changeable {
    init(copy: ChangeableWrapper<SleepView.Model>) {
        self.init(state: copy.state, alarm: copy.alarm)
    }
}

fileprivate extension UIButton {
    func centerTextAndImage(spacing: CGFloat) {
        let insetAmount = spacing / 2
        imageEdgeInsets = UIEdgeInsets(top: 0, left: -insetAmount, bottom: 0, right: insetAmount)
        titleEdgeInsets = UIEdgeInsets(top: 0, left: insetAmount, bottom: 0, right: -insetAmount)
        contentEdgeInsets = UIEdgeInsets(top: 0, left: insetAmount, bottom: 0, right: insetAmount)
    }
}
