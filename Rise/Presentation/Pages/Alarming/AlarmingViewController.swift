//
//  AlarmingViewController.swift
//  Rise
//
//  Created by Vladimir Korolev on 08.01.2021.
//  Copyright © 2021 VladimirBrejcha. All rights reserved.
//

import UIKit
import Core

final class AlarmingViewController: UIViewController, ViewController {

  enum OutCommand {
    case alarmStopped
    case alarmSnoozed(newAlarmTime: Date)
  }

  typealias Deps = HasChangeScreenBrightnessUseCase
  typealias View = AlarmingView

  private let out: Out
  private let changeScreenBrightness: ChangeScreenBrightness

  // MARK: - LifeCycle

  init(deps: Deps, out: @escaping Out) {
    self.changeScreenBrightness = deps.changeScreenBrightness
    self.out = out
    super.init(nibName: nil, bundle: nil)
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  deinit {
    changeScreenBrightness(to: .userDefault)
  }

  override func loadView() {
    super.loadView()

    self.view = View(
      stopHandler: { [unowned self] in out(.alarmStopped) },
      snoozeHandler: { [unowned self] in
        out(.alarmSnoozed(
          newAlarmTime: Date().addingTimeInterval(minutes: 8))
        )
      },
      currentTimeDataSource: { Date().HHmmString }
    )
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    changeScreenBrightness(to: .high)
  }

  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    changeScreenBrightness(to: .userDefault)
  }
}
