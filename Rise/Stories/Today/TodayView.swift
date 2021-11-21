//
//  TodayView.swift
//  Rise
//
//  Created by Vladimir Korolev on 01.08.2020.
//  Copyright © 2020 VladimirBrejcha. All rights reserved.
//

import UIKit

final class TodayView: UIView {

    private let sleepHandler: () -> Void
    private let adjustScheduleHandler: () -> Void
    private let timeUntilSleepDataSource: () -> FloatingLabel.Model

    // MARK: - Subviews

    private lazy var buttonsVStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 8
        return stack
    }()

    private lazy var sleepButton: Button = {
        let button = Button()
        button.setTitle(Text.sleep, for: .normal)
        button.onTouchUp = { [weak self] _ in self?.sleepHandler() }
        return button
    }()

    private lazy var adjustScheduleButton: Button = {
        let button = View.closeableButton(
            touchHandler: { [weak self] in
                self?.adjustScheduleHandler()
            },
            closeHandler: { [weak self] in
                self?.adjustScheduleButton.isHidden = true
            },
            style: .secondary
        )
        button.setTitle(Text.adjustSchedule, for: .normal)
        return button
    }()

    private lazy var timeUntilSleepLabel: FloatingLabel = {
        let label = FloatingLabel()
        label.applyStyle(.footer)
        label.dataSource = timeUntilSleepDataSource
        return label
    }()

    private var daysView: DaysView!

    // MARK: - LifeCycle

    init(
        timeUntilSleepDataSource: @escaping () -> FloatingLabel.Model,
        sleepHandler: @escaping () -> Void,
        showAdjustSchedule: Bool,
        adjustScheduleHandler: @escaping () -> Void,
        daysView: DaysView
    ) {
        self.sleepHandler = sleepHandler
        self.adjustScheduleHandler = adjustScheduleHandler
        self.timeUntilSleepDataSource = timeUntilSleepDataSource
        self.daysView = daysView
        super.init(frame: .zero)
        adjustScheduleButton.isHidden = !showAdjustSchedule
        setupViews()
        setupLayout()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("This class does not support NSCoder")
    }

    private func setupViews() {
        addBackgroundView()
        addSubviews(
            daysView,
            timeUntilSleepLabel,
            buttonsVStack.addArrangedSubviews(
                sleepButton,
                adjustScheduleButton
            )
        )
        timeUntilSleepLabel.beginRefreshing()
    }

    func allowAdjustSchedule(_ allow: Bool) {
        adjustScheduleButton.isHidden = !allow
    }

    // MARK: - Layout

    private func setupLayout() {
        buttonsVStack.activateConstraints(
            buttonsVStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            buttonsVStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            buttonsVStack.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -30)
        )
        buttonsVStack.arrangedSubviews.forEach { view in
            view.activateConstraints(
                view.heightAnchor.constraint(equalToConstant: 50)
            )
        }
        timeUntilSleepLabel.activateConstraints(
            timeUntilSleepLabel.bottomAnchor.constraint(equalTo: sleepButton.topAnchor, constant: -20),
            timeUntilSleepLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            timeUntilSleepLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10)
        )
        daysView.activateConstraints(
            {
                if UIScreen.main.bounds.height <= 568 /* iPhone SE and smaller */ {
                    return daysView.bottomAnchor.constraint(equalTo: timeUntilSleepLabel.topAnchor, constant: -20)
                } else {
                    return daysView.centerYAnchor.constraint(equalTo: safeAreaLayoutGuide.centerYAnchor)
                }
            }(),
            daysView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            daysView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            {
                if UIScreen.main.bounds.height <= 568 /* iPhone SE and smaller */ {
                    return daysView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 20)
                } else {
                    return daysView.heightAnchor.constraint(greaterThanOrEqualTo: heightAnchor, multiplier: 0.42)
                }
            }()
        )
    }
}
