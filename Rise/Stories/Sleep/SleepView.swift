//
//  SleepView.swift
//  Rise
//
//  Created by Vladimir Korolev on 13.08.2020.
//  Copyright © 2020 VladimirBrejcha. All rights reserved.
//

import UIKit

final class SleepView: UIView {

    private let stopHandler: () -> Void

    // MARK: - Subviews

    private lazy var titleView: UIView = View.Title.make(
        title: Text.sleeping,
        closeButton: .none
    )

    private lazy var currentTimeLabel: AutoRefreshableLabel = {
        let label = AutoRefreshableLabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 54, weight: .medium)
        label.textColor = Asset.Colors.white.color
        return label
    }()

    private lazy var alarmAtLabel: UILabel = {
        let label = UILabel()
        label.applyStyle(.mediumSizedBody)
        label.textAlignment = .center
        return label
    }()

    private lazy var wakeUpInLabel: FloatingLabel = {
        let label = FloatingLabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = Asset.Colors.white.color
        return label
    }()

    private lazy var stopButton: LongPressProgressButton = {
        let button = LongPressProgressButton()
        button.title = Text.stop
        button.progressCompleted = { [weak self] _ in
            self?.stopHandler()
        }
        return button
    }()

    // MARK: - LifeCycle

    init(
        currentTimeDataSource: @escaping () -> String,
        wakeUpInDataSource: @escaping () -> FloatingLabel.Model,
        alarmTime: String,
        stopHandler: @escaping () -> Void
    ) {
        self.stopHandler = stopHandler
        super.init(frame: .zero)
        self.currentTimeLabel.dataSource = currentTimeDataSource
        self.wakeUpInLabel.dataSource = wakeUpInDataSource
        alarmAtLabel.text = alarmTime
        setupViews()
        setupLayout()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("This class does not support NSCoder")
    }

    private func setupViews() {
        addBackgroundView(.rich, blur: .dark)
        addScreenTitleView(titleView)
        addSubviews(
            currentTimeLabel,
            alarmAtLabel,
            wakeUpInLabel,
            stopButton
        )

        currentTimeLabel.beginRefreshing()
        wakeUpInLabel.beginRefreshing()
    }

    // MARK: - Layout

    private func setupLayout() {
        currentTimeLabel.activateConstraints(
            currentTimeLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            currentTimeLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            currentTimeLabel.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -20)
        )
        alarmAtLabel.activateConstraints(
            alarmAtLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            alarmAtLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            alarmAtLabel.topAnchor.constraint(equalTo: currentTimeLabel.bottomAnchor, constant: 10)
        )
        wakeUpInLabel.activateConstraints(
            wakeUpInLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            wakeUpInLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            wakeUpInLabel.bottomAnchor.constraint(equalTo: stopButton.topAnchor, constant: -10)
        )
        stopButton.activateConstraints(
            stopButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            stopButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            stopButton.heightAnchor.constraint(equalToConstant: 62),
            stopButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -30)
        )
    }
}
