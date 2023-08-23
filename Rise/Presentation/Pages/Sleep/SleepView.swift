//
//  SleepView.swift
//  Rise
//
//  Created by Vladimir Korolev on 13.08.2020.
//  Copyright © 2020 VladimirBrejcha. All rights reserved.
//

import UIKit
import Localization
import UILibrary

final class SleepView: UIView {

  private let stopHandler: () -> Void
  private let keepAppOpenedHandler: () -> Void
  private var shouldRestartAnimationOnWakeUpLabel = false

  // MARK: - Subviews

  private lazy var titleView: UIView = Title.make(
    title: Text.sleeping,
    closeButton: .none
  )

  private lazy var currentTimeLabel: AutoRefreshableLabel = {
    let label = AutoRefreshableLabel()
    label.textAlignment = .center
    label.applyStyle(.largeTime)
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
    label.applyStyle(.floating)
    return label
  }()

  private lazy var buttonsVStack: UIStackView = {
    let stack = UIStackView()
    stack.axis = .vertical
    stack.spacing = 8
    return stack
  }()

  private lazy var keepAppOpenedButton: Button = {
    let button = closeableButton(
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
      currentTimeLabel.activateConstraints {
          [$0.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
          $0.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
          $0.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -20)]
      }
      alarmAtLabel.activateConstraints {
          [$0.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
          $0.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
          $0.topAnchor.constraint(equalTo: currentTimeLabel.bottomAnchor, constant: 10)]
      }
      wakeUpInLabel.activateConstraints {
          [$0.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
          $0.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
          $0.bottomAnchor.constraint(equalTo: buttonsVStack.topAnchor, constant: -10)]
      }
      buttonsVStack.activateConstraints {
          [$0.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 40),
          $0.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -40),
          $0.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -30)]
      }
      stopButton.activateConstraints {
          [$0.heightAnchor.constraint(equalToConstant: 56)]
      }
      keepAppOpenedButton.activateConstraints {
          [$0.heightAnchor.constraint(equalToConstant: 44)]
      }
  }
}
