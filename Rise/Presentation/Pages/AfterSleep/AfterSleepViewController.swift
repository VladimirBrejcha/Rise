//  
//  AfterSleepViewController.swift
//  Rise
//
//  Created by Vladimir Korolev on 24.11.2021.
//  Copyright © 2021 VladimirBrejcha. All rights reserved.
//

import UIKit
import Core
import DomainLayer

final class AfterSleepViewController: UIViewController, ViewController {

  enum OutCommand {
    case adjustSchedule(currentSchedule: Schedule, toBed: Date)
    case finish
  }

  typealias Deps = HasManageActiveSleepUseCase & HasGetScheduleUseCase
  typealias View = AfterSleepView

  private let manageActiveSleep: ManageActiveSleep
  private let yesterdaySchedule: Schedule?
  private let out: Out

  private let todaySchedule: Schedule?
  private let wentSleepTime: Date
  private let totalSleepTime: Int
  private let currentTime: Date = Date()

  // MARK: - LifeCycle

  init(deps: Deps, out: @escaping Out) {
    self.manageActiveSleep = deps.manageActiveSleep
    self.todaySchedule = deps.getSchedule.today()
    self.yesterdaySchedule = deps.getSchedule.yesterday()
    self.wentSleepTime = deps.manageActiveSleep.sleepStartedAt ?? Date()
    self.totalSleepTime = Int(currentTime.timeIntervalSince(wentSleepTime)) / 60
    self.out = out
    super.init(nibName: nil, bundle: nil)
    manageActiveSleep.endSleep()
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func loadView() {
    super.loadView()
    self.view = AfterSleepView(
      doneHandler: { [unowned self] in
        out(.finish)
      },
      adjustScheduleHandler: { [unowned self] in
        if let schedule = todaySchedule {
          out(.adjustSchedule(currentSchedule: schedule, toBed: wentSleepTime))
        }
      },
      appearance: .sleepFinished,
      descriptionText: makeDescriptionText(
        wentSleepTime: wentSleepTime.HHmmString,
        lateBy: {
          guard let schedule = yesterdaySchedule else {
            return nil
          }
          let minutes = minutes(
            sinceScheduled: schedule,
            wentSleepAt: wentSleepTime
          )
          return minutes > 0 ? minutes.HHmmString : nil
        }(),
        wokeUpTime: currentTime.HHmmString,
        totalSleepTime: totalSleepTime > 0 ? totalSleepTime.HHmmString : nil
      ),
      showAdjustSchedule: shouldAdjustSchedule(
        schedule: yesterdaySchedule,
        wentSleepTime: wentSleepTime
      )
    )
  }

  private func makeDescriptionText(
    wentSleepTime: String,
    lateBy: String?,
    wokeUpTime: String,
    totalSleepTime: String?
  ) -> String {
    var string = "You went to bed at \(wentSleepTime)"
    if let lateBy = lateBy {
      string.append(contentsOf: "\nit's \(lateBy) later than scheduled\n")
    }
    string.append(contentsOf: "\nYou woke up at \(wokeUpTime)")
    if let totalSleepTime = totalSleepTime {
      string.append(contentsOf: "\nwhich is a total of \(totalSleepTime) of sleep")
    }
    return string
  }

  private func shouldAdjustSchedule(
    schedule: Schedule?,
    wentSleepTime: Date
  ) -> Bool {
    guard let schedule = schedule else {
      return false
    }
    return (-20...20)
      .contains(
        minutes(sinceScheduled: schedule, wentSleepAt: wentSleepTime)
      )
  }

  private func minutes(sinceScheduled: Schedule, wentSleepAt: Date) -> Int {
    calendar.dateComponents(
      [.minute],
      from: sinceScheduled.toBed.changeDayStoringTime(to: wentSleepAt),
      to: wentSleepAt
    ).minute ?? 0
  }
}
