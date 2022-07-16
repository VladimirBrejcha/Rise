//
//  PrepareToSleepViewController.swift
//  Rise
//
//  Created by Vladimir Korolev on 11.03.2020.
//  Copyright © 2020 VladimirBrejcha. All rights reserved.
//

import UIKit
import Core
import DomainLayer

final class PrepareToSleepViewController: UIViewController, ViewController {

  @IBOutlet private var prepareToSleepView: PrepareToSleepView!

  enum OutCommand {
    case showKeepAppOpenedSuggestion(completion: () -> Void)
    case finish
    case showSleep(wakeUp: Date)
  }

  typealias View = PrepareToSleepView
  typealias Deps =
  HasGetScheduleUseCase
  & HasPreferredWakeUpTimeUseCase
  & HasSuggestKeepAppOpenedUseCase
  & HasManageActiveSleepUseCase

  var out: Out! // DI
  var deps: Deps! // DI

  private var customSelectedWakeUpTime: Date?

  private var wakeUpTime: Date {
    if let schedule = schedule {
      return customSelectedWakeUpTime ?? schedule.wakeUp
    } else {
      return customSelectedWakeUpTime ?? deps.preferredWakeUpTime.time ?? Date()
    }
  }

  private var schedule: Schedule?

  // MARK: - LifeCycle

  override func viewDidLoad() {
    super.viewDidLoad()

    guard let hours = calendar.dateComponents([.hour], from: Date()).hour else {
      out(.finish)
      return
    }

    if hours < 6 {
      schedule = deps.getSchedule.today()
    } else {
      schedule = deps.getSchedule.tomorrow()
    }

    rootView.configure(
      model: PrepareToSleepView.Model(
        toSleepText: motivatingText,
        title: "Prepare to sleep",
        startSleepText: "begin to sleep",
        wakeUpTitle: "Alarm at \(wakeUpTime.HHmmString)",
        wakeUpTime: wakeUpTime
      ),
      dataSource: PrepareToSleepView.DataSource(
        timeUntilWakeUp: { [weak self] () -> String in
          guard let self = self else { return "" }
          let wakeUpTime = self.wakeUpTime.fixIfNeeded()
          return "\(wakeUpTime.timeIntervalSinceNow.HHmmString) until wake up"
        }
      ),
      handlers: PrepareToSleepView.Handlers(
        wakeUp: { [weak self] in
          if let self = self {
            self.prepareToSleepView.state = self.prepareToSleepView.state == .normal
            ? .expanded
            : .normal
          }
        },
        sleep: { [weak self] in
          guard let self = self else { return }
          if self.deps.suggestKeepAppOpened.shouldSuggest {
            self.deps.suggestKeepAppOpened.shouldSuggest = false
            self.out(.showKeepAppOpenedSuggestion(completion: self.goToSleep))
          } else {
            self.goToSleep()
          }
        },
        close: { [weak self] in
          self?.out(.finish)
        },
        wakeUpTimeChanged: { [weak self] newValue in
          self?.customSelectedWakeUpTime = newValue
          self?.deps.preferredWakeUpTime.time = newValue
          self?.prepareToSleepView.model = self?.prepareToSleepView.model?.changing { model in
            model.wakeUpTime = newValue
            model.wakeUpTitle = "Alarm at \(newValue.HHmmString)"
          }
        }
      )
    )
  }

  // MARK: - Make motivating text

  private var motivatingText: String {
    if let time = schedule?.toBed {
      return makeMotivatingText(with: time)
    } else {
      return "Have a good night!"
    }
  }

  private func makeMotivatingText(with time: Date) -> String {
    let timeSinceNow = time.timeIntervalSinceNow
    if timeSinceNow.isNearby {
      return "You are just in time today!"
    } else if timeSinceNow > 0 {
      return "Good night, sleep well"
    } else /* if timeSinceNow < 0 */ {
      return "You are a little late today, it happens with all of us. Sleep well!"
    }
  }

  // MARK: - Private -

  private func goToSleep() {
    deps.manageActiveSleep.sleepStartedAt = Date()
    out(.showSleep(wakeUp: wakeUpTime))
  }
}

fileprivate extension Date {
  func fixIfNeeded() -> Date {
    if self < Date() {
      return self.changeDayStoringTime(to: .tomorrow)
    } else {
      return self
    }
  }

  var timeIntervalSinceNow: TimeInterval {
    timeIntervalSince(Date())
  }
}

fileprivate extension TimeInterval {
  var isNearby: Bool {
    toMinutes() > -10 && toMinutes() < 10
  }
}
