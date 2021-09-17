//
//  SleepView.swift
//  Rise
//
//  Created by Vladimir Korolev on 13.08.2020.
//  Copyright © 2020 VladimirBrejcha. All rights reserved.
//

import UIKit

final class SleepView: UIView, Statefull {

    @IBOutlet private var currentTimeLabel: AutoRefreshableLabel!
    @IBOutlet private var stopButton: LongPressProgressButton!
    @IBOutlet private var timeLeftLabel: FloatingLabel!
    @IBOutlet private var editAlarmButton: UIButton!
    @IBOutlet private var editAlarmDatePicker: UIDatePicker!
    @IBOutlet private var cancelEditAlarmButton: UIButton!
    @IBOutlet private var saveAlarmEditButton: UIButton!
    @IBOutlet private var backgroundImage: UIImageView!
    @IBOutlet private var editAlarmButtonContainer: UIView!
    @IBOutlet private var datePickerBackground: UIView!

    private var editAlarmHandler: (() -> Void)?
    private var cancelAlarmEditHandler: (() -> Void)?
    private var saveAlarmEditHandler: (() -> Void)?
    private var alarmTimeChangedHandler: ((Date) -> Void)?

    private let defaultControlAlpha: CGFloat = 0.9

    // MARK: - Statefull
    private(set) var state: State?

    func setState(_ state: State) {
        if let currentState = self.state, currentState == state {
            log(.info, "Skipping equal state \(state)")
            return
        }

        self.state = state

        UIView.animate(withDuration: 0.2) { [self] in
            [editAlarmButtonContainer,
             editAlarmButton,
             cancelEditAlarmButton,
             saveAlarmEditButton,
             editAlarmDatePicker,
             datePickerBackground].invertAlpha(max: defaultControlAlpha)
        }

        switch state {
        case .normal (let alarm):
            editAlarmButton.setTitle(alarm.HHmmString, for: .normal)
        case .editingAlarm (let alarm):
            editAlarmDatePicker.date = alarm
        }
    }

    enum State: Equatable {
        case normal (alarm: Date)
        case editingAlarm (alarm: Date)
    }

    struct DataSource {
        let timeLeft: () -> FloatingLabel.Model
        let currentTime: () -> String
    }
    
    func configure(
        initialState state: State,
        dataSource: DataSource,
        editAlarmHandler: @escaping () -> Void,
        cancelAlarmEditHandler: @escaping () -> Void,
        saveAlarmEditHandler: @escaping () -> Void,
        alarmTimeChangedHandler: @escaping (Date) -> Void,
        stopHandler: @escaping () -> Void
    ) {
        datePickerBackground.backgroundColor = .white.withAlphaComponent(0.4)
        datePickerBackground.layer.cornerRadius = 8

        backgroundImage.applyBlur(style: .dark)

        editAlarmButton.setImage(UIImage(systemName: "bell.fill"), for: .normal)
        editAlarmButton.centerTextAndImage(spacing: 8)
        editAlarmButton.tintColor = .white
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

        editAlarmButtonContainer.alpha = defaultControlAlpha
        editAlarmButton.alpha = defaultControlAlpha
        datePickerBackground.alpha = 0
        cancelEditAlarmButton.alpha = 0
        saveAlarmEditButton.alpha = 0
        editAlarmDatePicker.alpha = 0

        self.editAlarmHandler = editAlarmHandler
        self.cancelAlarmEditHandler = cancelAlarmEditHandler
        self.saveAlarmEditHandler = saveAlarmEditHandler
        self.alarmTimeChangedHandler = alarmTimeChangedHandler

        editAlarmButtonContainer.layer.cornerRadius = 12
        editAlarmButtonContainer.backgroundColor = Asset.Colors.white.color.withAlphaComponent(0.1)

        self.state = state
        if case .normal (let alarm) = state {
            editAlarmButton.setTitle(alarm.HHmmString, for: .normal)
        }
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

fileprivate extension UIButton {
    func centerTextAndImage(spacing: CGFloat) {
        let insetAmount = spacing / 2
        imageEdgeInsets = UIEdgeInsets(top: 0, left: -insetAmount, bottom: 0, right: insetAmount)
        titleEdgeInsets = UIEdgeInsets(top: 0, left: insetAmount, bottom: 0, right: -insetAmount)
        contentEdgeInsets = UIEdgeInsets(top: 0, left: insetAmount, bottom: 0, right: insetAmount)
    }
}
