//
//  AlarmingView.swift
//  Rise
//
//  Created by Vladimir Korolev on 08.01.2021.
//  Copyright © 2021 VladimirBrejcha. All rights reserved.
//

import UIKit

final class AlarmingView: UIView {

    private let stopHandler: () -> Void
    private let snoozeHandler: () -> Void

    // MARK: - Subviews

    private lazy var titleView: UIView = View.Title.make(
        title: Text.Alarming.title,
        closeButton: .none
    )

    private lazy var currentTimeLabel: AutoRefreshableLabel = {
        let label = AutoRefreshableLabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 54, weight: .medium)
        label.textColor = Asset.Colors.white.color
        return label
    }()

    private lazy var buttonsVStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 8
        return stack
    }()

    private lazy var snoozeButton: Button = {
        let button = Button()
        button.setTitle(Text.Alarming.snooze, for: .normal)
        button.onTouchUp = { [weak self] _ in
            self?.snoozeHandler()
        }
        button.applyStyle(.secondary)
        return button
    }()

    private lazy var stopButton: LongPressProgressButton = {
        let button = LongPressProgressButton()
        button.title = Text.Alarming.stop
        button.progressCompleted = { [weak self] _ in
            self?.stopHandler()
        }
        return button
    }()

    // MARK: - LifeCycle

    init(
        stopHandler: @escaping () -> Void,
        snoozeHandler: @escaping () -> Void,
        currentTimeDataSource: @escaping () -> String
    ) {
        self.stopHandler = stopHandler
        self.snoozeHandler = snoozeHandler
        super.init(frame: .zero)
        self.currentTimeLabel.dataSource = currentTimeDataSource
        setupViews()
        setupLayout()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("This class does not support NSCoder")
    }

    private func setupViews() {
        addBackgroundView(.rich, blur: .light)
        addScreenTitleView(titleView)
        addSubviews(
            currentTimeLabel,
            buttonsVStack.addArrangedSubviews(
                snoozeButton,
                stopButton
            )
        )
        currentTimeLabel.beginRefreshing()
    }

    // MARK: - Layout

    private func setupLayout() {
        currentTimeLabel.activateConstraints(
            currentTimeLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            currentTimeLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            currentTimeLabel.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -20)
        )
        buttonsVStack.activateConstraints(
            buttonsVStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            buttonsVStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            buttonsVStack.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -30)
        )
        stopButton.activateConstraints(
            stopButton.heightAnchor.constraint(equalToConstant: 62)
        )
        snoozeButton.activateConstraints(
            snoozeButton.heightAnchor.constraint(equalToConstant: 50)
        )
    }
}
