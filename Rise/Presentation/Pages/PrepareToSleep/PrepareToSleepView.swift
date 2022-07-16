//
//  PrepareToSleepView.swift
//  Rise
//
//  Created by Vladimir Korolev on 13.08.2020.
//  Copyright © 2020 VladimirBrejcha. All rights reserved.
//

import UIKit
import Core

final class PrepareToSleepView: UIView, PropertyAnimatable {

  // MARK: - PropertyAnimatable

  var propertyAnimationDuration: Double = 0.3

  @IBOutlet private var backgroundImageView: UIImageView!
  @IBOutlet private var titleLabel: UILabel!
  @IBOutlet private var startSleepButton: FloatingButton!
  @IBOutlet private var startSleepLabel: UILabel!
  @IBOutlet private var wakeUpContainerHeightConstraint: NSLayoutConstraint!
  @IBOutlet private var wakeUpTitleLabel: UILabel!
  @IBOutlet private var wakeUpDatePicker: UIDatePicker!
  @IBOutlet private var timeUntilWakeUpLabel: AutoRefreshableLabel!
  @IBOutlet private var toSleepLabel: UILabel!
  @IBOutlet private var timeUntilWakeUpTopConstraint: NSLayoutConstraint!
  @IBOutlet private var fadeView: HorizontalFadeView!

  // MARK: - State

  enum State: Equatable {
    case normal
    case expanded
  }
  var state: State = .normal {
    didSet {
      animate {
        [self.toSleepLabel, self.wakeUpDatePicker, self.wakeUpTitleLabel].invertAlpha()

        if self.state == .normal {
          self.fadeView.transform = CGAffineTransform.identity
          self.wakeUpContainerHeightConstraint.constant = 50
          self.timeUntilWakeUpTopConstraint.constant = 16
        } else if self.state == .expanded {
          self.fadeView.transform = CGAffineTransform(scaleX: 1, y: 0.8)
          self.wakeUpContainerHeightConstraint.constant = 200
          self.timeUntilWakeUpTopConstraint.constant = -4
        }

        self.layoutIfNeeded()
      }
    }
  }

  // MARK: - Model
  struct Model {
    let toSleepText: String
    let title: String
    let startSleepText: String
    let wakeUpTitle: String
    let wakeUpTime: Date
  }
  var model: Model? {
    didSet {
      if let model = model {
        toSleepLabel.text = model.toSleepText
        titleLabel.text = model.title
        startSleepLabel.text = model.startSleepText
        wakeUpTitleLabel.text = model.wakeUpTitle
        wakeUpDatePicker.date = model.wakeUpTime
      }
    }
  }

  struct DataSource {
    let timeUntilWakeUp: () -> String
  }

  // MARK: - Handlers
  struct Handlers {
    let wakeUp: () -> Void
    let sleep: () -> Void
    let close: () -> Void
    let wakeUpTimeChanged: (Date) -> Void
  }
  private var handlers: Handlers?

  @IBAction private func startSleepTouchUp(_ sender: FloatingButton) {
    handlers?.sleep()
  }

  @IBAction private func closeTouchUp(_ sender: UIButton) {
    handlers?.close()
  }

  @IBAction private func wakeUpValueChanged(_ sender: UIDatePicker) {
    handlers?.wakeUpTimeChanged(sender.date)
  }

  @IBAction func handleTimeTouchUp(_ sender: UITapGestureRecognizer) {
    handlers?.wakeUp()
  }

  // MARK: - Configure
  private var isConfigured = false
  func configure(model: Model, dataSource: DataSource, handlers: Handlers) {
    if isConfigured { return }

    self.model = model
    self.handlers = handlers
    timeUntilWakeUpLabel.dataSource = dataSource.timeUntilWakeUp
    timeUntilWakeUpLabel.beginRefreshing()

    wakeUpDatePicker.applyStyle(.usual)

    startSleepButton.backgroundColor = .clear
    startSleepButton.alpha = 0.9

    backgroundImageView.applyBlur(style: .dark)

    isConfigured = true
  }
}

extension PrepareToSleepView.Model: Changeable {
  init(copy: ChangeableWrapper<PrepareToSleepView.Model>) {
    self.init(
      toSleepText: copy.toSleepText,
      title: copy.title,
      startSleepText: copy.startSleepText,
      wakeUpTitle: copy.wakeUpTitle,
      wakeUpTime: copy.wakeUpTime
    )
  }
}
