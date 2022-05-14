//
//  CreateScheduleViewController.swift
//  Rise
//
//  Created by Vladimir Korolev on 25/05/2019.
//  Copyright © 2019-2020 VladimirBrejcha. All rights reserved.
//

import UIKit

final class CreateScheduleViewController:
  UIViewController,
  UIAdaptivePresentationControllerDelegate,
  AlertCreatable,
  AlertPresentable
{
  @IBOutlet private var createScheduleView: CreateScheduleView!

  private var pageController: UIPageViewController!

  enum Stage {
    case welcome
    case sleepDuration(
      sleepDurationOutput: (Int) -> Void,
      currentSleepDuration: () -> Schedule.Minute?
    )
    case wakeUpTime(
      toBedTimeOutput: (Date) -> Void,
      wakeUpTimeOutput: (Date) -> Void,
      currentSleepDuration: () -> Schedule.Minute?,
      currentWakeUpTime: () -> Date?
    )
    case intensity(
      scheduleIntensityOutput: (Schedule.Intensity) -> Void,
      currentIntensity: () -> Schedule.Intensity?
    )
    case wentSleep(
      wentSleepOutput: (Date) -> Void,
      currentWentSleepTime: () -> Date?
    )
    case scheduleCreated

    var vc: UIViewController {
      switch self {
      case .welcome:
          return Storyboard.createSchedule.instantiateViewController(
              of: WelcomeCreateScheduleViewController.self
          )
      case let .sleepDuration(sleepDurationOutput, currentSleepDuration):
          let controller = Storyboard.createSchedule.instantiateViewController(
              of: SleepDurationCreateScheduleViewController.self
          )
          controller.sleepDurationOutput = sleepDurationOutput
          controller.currentSleepDuration = currentSleepDuration
          return controller
      case let .wakeUpTime(
          toBedTimeOutput, wakeUpTimeOutput, currentSleepDuration, currentWakeUpTime
      ):
          let controller = Storyboard.createSchedule.instantiateViewController(
              of: WakeUpTimeCreateScheduleViewController.self
          )
          controller.toBedTimeOutput = toBedTimeOutput
          controller.wakeUpTimeOutput = wakeUpTimeOutput
          controller.currentSleepDuration = currentSleepDuration
          controller.currentWakeUpTime = currentWakeUpTime
          return controller
      case let .intensity(scheduleIntensityOutput, currentIntensity):
          let controller = Storyboard.createSchedule.instantiateViewController(
              of: IntensityCreateScheduleViewController.self
          )
          controller.scheduleIntensityOutput = scheduleIntensityOutput
          controller.currentIntensity = currentIntensity
          return controller
      case let .wentSleep(wentSleepOutput, currentWentSleepTime):
          let controller = Storyboard.createSchedule.instantiateViewController(
              of: WentSleepCreateScheduleViewController.self
          )
          controller.wentSleepTimeOutput = wentSleepOutput
          controller.currentWentSleepTime = currentWentSleepTime
          return controller
      case .scheduleCreated:
          let controller = Storyboard.createSchedule.instantiateViewController(
              of: ScheduleCreatedCreateScheduleViewController.self
          )
          return controller
      }
    }
  }

  var createSchedule: CreateSchedule! // DI
  var saveSchedule: SaveSchedule! // DI
  var stages: [Stage]! // DI

  // opened for DI into PageController controllers

  private(set) var chosenSleepDuration: Schedule.Minute = 8 * 60
  private(set) var chosenWakeUpTime: Date?
  private(set) var chosenToBedTime: Date?
  private(set) var chosenIntensity: Schedule.Intensity = .normal
  private(set) var chosenLastTimeWentSleep: Date?

  private var currentPage = 0
  private var currentStage: Stage { stages[currentPage] }

  override func viewDidLoad() {
    super.viewDidLoad()

    presentationController?.delegate = self

    createScheduleView.configure(
      model: .init(
        backButtonTitle: "",
        nextButtonTitle: "Start"
      ),
      handlers: .init(
        close: { [weak self] in
          self?.dismiss()
        },
        back: { [weak self] in
          self?.goToPrevPage()
        },
        next: { [weak self] in
          guard let self = self else { return }
          switch self.currentStage {
          case .scheduleCreated:
            self.dismiss()
          case .wentSleep:
            do {
              try self.generateSchedule()
              self.goToNextPage()
            } catch {
              self.presentAlert(
                from: self.recoverableError(from: error)
              )
            }
          default:
            self.goToNextPage()
          }
        }
      )
    )
    showNextStage(direction: .forward)
  }

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if let pageController = segue.destination as? UIPageViewController {
      self.pageController = pageController
    }
  }

  // opened for DI into PageController controllers

  func sleepDurationValueChanged(_ value: Schedule.Minute) {
    chosenSleepDuration = value
    updateButtonsWithCurrentStory()
  }

  func wakeUpTimeValueChanged(_ value: Date) {
    chosenWakeUpTime = value
    updateButtonsWithCurrentStory()
  }

  func toBedTimeValueChanged(_ value: Date) {
    chosenToBedTime = value
  }

  func intensityValueChanged(_ value: Schedule.Intensity) {
    chosenIntensity = value
    updateButtonsWithCurrentStory()
  }

  func lastTimeWentSleepValueChanged(_ value: Date) {
    chosenLastTimeWentSleep = value
    updateButtonsWithCurrentStory()
  }

  // MARK: - UIAdaptivePresentationControllerDelegate -

  func presentationControllerShouldDismiss(_ presentationController: UIPresentationController) -> Bool {
    false
  }

  // MARK: - Private -

  private func dismiss(completion: (() -> Void)? = nil) {
    dismiss(animated: true, completion: completion)
  }

  private func goToPrevPage() {
    if stages.indices.contains(currentPage - 1) {
      currentPage -= 1
      showNextStage(direction: .reverse)
      updateButtonsWithCurrentStory()
    }
  }

  private func goToNextPage() {
    if stages.indices.contains(currentPage + 1) {
      currentPage += 1
      showNextStage(direction: .forward)
      updateButtonsWithCurrentStory()
    }
  }

  private func showNextStage(direction: UIPageViewController.NavigationDirection) {
    pageController.setViewControllers(
      [currentStage.vc],
      direction: direction,
      animated: true
    )
  }

  private func updateButtonsWithCurrentStory() {
    let next = "Next"
    let prev = "Previous"
    switch currentStage {
    case .welcome:
      createScheduleView.state = .init(
        nextButtonEnabled: true,
        backButtonHidden: true
      )
      createScheduleView.model = .init(
        backButtonTitle: "",
        nextButtonTitle: "Start"
      )
    case .sleepDuration:
      createScheduleView.state = .init(
        nextButtonEnabled: true,
        backButtonHidden: true
      )
      createScheduleView.model = .init(
        backButtonTitle: "",
        nextButtonTitle: next
      )
    case .wakeUpTime:
      createScheduleView.state = .init(
        nextButtonEnabled: chosenWakeUpTime != nil,
        backButtonHidden: false
      )
      createScheduleView.model = .init(
        backButtonTitle: prev,
        nextButtonTitle: next
      )
    case .intensity:
      createScheduleView.state = .init(
        nextButtonEnabled: true,
        backButtonHidden: false
      )
      createScheduleView.model = .init(
        backButtonTitle: prev,
        nextButtonTitle: next
      )
    case .wentSleep:
      createScheduleView.state = .init(
        nextButtonEnabled: chosenLastTimeWentSleep != nil,
        backButtonHidden: false
      )
      createScheduleView.model = .init(
        backButtonTitle: prev,
        nextButtonTitle: "Create"
      )
    case .scheduleCreated:
      createScheduleView.state = .init(
        nextButtonEnabled: true,
        backButtonHidden: true
      )
      createScheduleView.model = .init(
        backButtonTitle: "",
        nextButtonTitle: "Great!"
      )
    }
  }

  private func generateSchedule() throws {
    if let chosenToBedTime = chosenToBedTime,
       let chosenLastTimeWentSleep = chosenLastTimeWentSleep {
      saveSchedule(
        createSchedule(
          wantedSleepDuration: chosenSleepDuration,
          currentToBed: chosenLastTimeWentSleep,
          wantedToBed: chosenToBedTime,
          intensity: chosenIntensity
        )
      )
    } else {
      throw Error.someFieldsAreMissing
    }
  }
}

extension CreateScheduleViewController {
  enum Error: LocalizedError {
    case someFieldsAreMissing

    var errorDescription: String? {
      switch self {
      case .someFieldsAreMissing:
        return "Could'not generate the schedule because some fields were missing, please try again"
      }
    }
    var recoverySuggestion: String? {
      switch self {
      case .someFieldsAreMissing:
        return "Try to fill all the fields"
      }
    }
  }

  func recoverableError(from error: Swift.Error) -> RecoverableError {
    RecoverableError(
      error: error,
      attempter: RecoveryAttempter(
        recoveryOptions: [
          .custom(
            title: "Leave Create screen",
            action: { [weak self] in
              log(
                .error,
                "There was an error creating the schedule \(error.localizedDescription)"
              )
              self?.dismiss()
            }
          ),
          .tryAgain(
            action: {
              log(
                .error,
                "There was an error creating the schedule \(error.localizedDescription)"
              )
            }
          )
        ]
      )
    )
  }
}

