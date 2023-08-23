//
//  AlarmingView.swift
//  Rise
//
//  Created by Vladimir Korolev on 08.01.2021.
//  Copyright © 2021 VladimirBrejcha. All rights reserved.
//

import UIKit
import Localization
import UILibrary

final class AlarmingView: UIView {
  
  private let stopHandler: () -> Void
  private let snoozeHandler: () -> Void
  
  // MARK: - Subviews
  
  private lazy var titleView: UIView = Title.make(
    title: Text.Alarming.title,
    closeButton: .none
  )
  
  private lazy var currentTimeLabel: AutoRefreshableLabel = {
    let label = AutoRefreshableLabel()
    label.textAlignment = .center
    label.applyStyle(.largeTime)
    label.layer.applyStyle(
        .init(shadow: .onboardingShadow)
    )
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
    button.onTouchUp = { [weak self] in
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
      currentTimeLabel.activateConstraints {
          [$0.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
          $0.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
          $0.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -20)]
      }
      buttonsVStack.activateConstraints {
          [$0.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 40),
          $0.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -40),
          $0.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -30)]
      }
      stopButton.activateConstraints {
          [$0.heightAnchor.constraint(equalToConstant: 56)]
      }
      snoozeButton.activateConstraints {
          [$0.heightAnchor.constraint(equalToConstant: 44)]
      }
  }
}
