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
    private let timeUntilSleepDataSource: () -> FloatingLabel.Model

    // MARK: - Subviews

    private lazy var backgroundImageView: UIImageView = {
        let view = UIImageView()
        view.image = Asset.Background.default.image
        view.contentMode = .scaleAspectFill
        return view
    }()

    private lazy var sleepButton: Button = {
        let button = Button()
        button.setTitle(Text.sleep, for: .normal)
        button.onTouchUp = { [weak self] _ in self?.sleepHandler() }
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

    init(timeUntilSleepDataSource: @escaping () -> FloatingLabel.Model,
         sleepHandler: @escaping () -> Void,
         daysView: DaysView
    ) {
        self.sleepHandler = sleepHandler
        self.timeUntilSleepDataSource = timeUntilSleepDataSource
        self.daysView = daysView
        super.init(frame: .zero)
        setupViews()
        setupLayout()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("This class does not support NSCoder")
    }

    private func setupViews() {
        addSubviews(
            backgroundImageView,
            daysView,
            timeUntilSleepLabel,
            sleepButton
        )
        timeUntilSleepLabel.beginRefreshing()
    }

    // MARK: - Layout

    private func setupLayout() {
        backgroundImageView.activateConstraints(
            backgroundImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            backgroundImageView.topAnchor.constraint(equalTo: topAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: bottomAnchor)
        )
        sleepButton.activateConstraints(
            sleepButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            sleepButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            sleepButton.heightAnchor.constraint(equalToConstant: 50),
            sleepButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -30)
        )
        timeUntilSleepLabel.activateConstraints(
            timeUntilSleepLabel.bottomAnchor.constraint(equalTo: sleepButton.topAnchor, constant: -20),
            timeUntilSleepLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            timeUntilSleepLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10)
        )
        daysView.activateConstraints(
            daysView.centerYAnchor.constraint(equalTo: safeAreaLayoutGuide.centerYAnchor),
            daysView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            daysView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            daysView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.45)
        )
    }
}
