//
//  TodayView.swift
//  Rise
//
//  Created by Vladimir Korolev on 01.08.2020.
//  Copyright © 2020 VladimirBrejcha. All rights reserved.
//

import UIKit
import Localization
import Core
import UILibrary

extension Today {

    final class View: UIView {

        private let sleepHandler: () -> Void
        private let adjustScheduleHandler: () -> Void
        private let closeAdjustScheduleHandler: () -> Void
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
            button.onTouchUp = { [weak self] in
                self?.sleepHandler()
            }
            return button
        }()

        private lazy var adjustScheduleButton: Button = {
            let button = closeableButton(
                touchHandler: { [weak self] in
                    self?.adjustScheduleHandler()
                },
                closeHandler: { [weak self] in
                    self?.closeAdjustScheduleHandler()
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

        private let daysView: Days.View

        // MARK: - LifeCycle

        init(
            timeUntilSleepDataSource: @escaping () -> FloatingLabel.Model,
            sleepHandler: @escaping () -> Void,
            showAdjustSchedule: Bool,
            adjustScheduleHandler: @escaping () -> Void,
            closeAdjustScheduleHandler: @escaping () -> Void,
            daysView: Days.View
        ) {
            self.sleepHandler = sleepHandler
            self.adjustScheduleHandler = adjustScheduleHandler
            self.closeAdjustScheduleHandler = closeAdjustScheduleHandler
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
            buttonsVStack.activateConstraints {
                [$0.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 40),
                 $0.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -40),
                 $0.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -32)]
            }
            buttonsVStack.arrangedSubviews.forEach { view in
                view.activateConstraints {
                    [$0.heightAnchor.constraint(equalToConstant: 44)]
                }
            }
            timeUntilSleepLabel.activateConstraints {
                [$0.bottomAnchor.constraint(equalTo: sleepButton.topAnchor, constant: -20),
                 $0.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
                 $0.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10)]
            }
            daysView.activateConstraints { v in
                [{
                    if UIScreen.isSmallSize {
                        return v.bottomAnchor.constraint(equalTo: timeUntilSleepLabel.topAnchor, constant: -20)
                    } else {
                        return v.centerYAnchor.constraint(equalTo: safeAreaLayoutGuide.centerYAnchor)
                    }
                }(),
                 v.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
                 v.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
                 {
                    if UIScreen.isSmallSize {
                        return v.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 100)
                    } else {
                        return v.heightAnchor.constraint(greaterThanOrEqualTo: heightAnchor, multiplier: 0.42)
                    }
                }()]
            }
        }
    }
}

extension UIScreen {
    /* iPhone SE 2 and smaller */
    static var isSmallSize: Bool {
        main.bounds.height <= 667
    }
}
