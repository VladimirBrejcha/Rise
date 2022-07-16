//
//  SleepView.swift
//  Rise
//
//  Created by Vladimir Korolev on 13.08.2020.
//  Copyright © 2020 VladimirBrejcha. All rights reserved.
//

import UIKit
import Localization

final class SleepView: UIView {

  private let stopHandler: () -> Void
  private let keepAppOpenedHandler: () -> Void
  private var shouldRestartAnimationOnWakeUpLabel = false

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

  private lazy var buttonsVStack: UIStackView = {
    let stack = UIStackView()
    stack.axis = .vertical
    stack.spacing = 8
    return stack
  }()

  private lazy var keepAppOpenedButton: Button = {
    let button = View.closeableButton(
      touchHandler: { [weak self] in
        self?.keepAppOpenedHandler()
      },
      closeHandler: { [weak self] in
        self?.shouldRestartAnimationOnWakeUpLabel = true
        self?.keepAppOpenedButton.isHidden = true
      },
      style: .secondary
    )
    button.setTitle(Text.KeepAppOpenedSuggestion.button, for: .normal)
    return button
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
    stopHandler: @escaping () -> Void,
    keepAppOpenedHandler: @escaping () -> Void
  ) {
    self.stopHandler = stopHandler
    self.keepAppOpenedHandler = keepAppOpenedHandler
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

  override func layoutSubviews() {
    super.layoutSubviews()
    if shouldRestartAnimationOnWakeUpLabel {
      shouldRestartAnimationOnWakeUpLabel = false
      wakeUpInLabel.restartAnimation()
    }
  }

  private func setupViews() {
    addBackgroundView(.rich, blur: .dark)
    addScreenTitleView(titleView)
    addSubviews(
      currentTimeLabel,
      alarmAtLabel,
      wakeUpInLabel,
      buttonsVStack.addArrangedSubviews(
        keepAppOpenedButton,
        stopButton
      )
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
      wakeUpInLabel.bottomAnchor.constraint(equalTo: buttonsVStack.topAnchor, constant: -10)
    )
    buttonsVStack.activateConstraints(
      buttonsVStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 40),
      buttonsVStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -40),
      buttonsVStack.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -30)
    )
    stopButton.activateConstraints(
      stopButton.heightAnchor.constraint(equalToConstant: 56)
    )
    keepAppOpenedButton.activateConstraints(
      keepAppOpenedButton.heightAnchor.constraint(equalToConstant: 44)
    )
  }
}
