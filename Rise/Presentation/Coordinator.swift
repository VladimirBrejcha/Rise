//
//  Coordinator.swift
//  Rise
//
//  Created by Vladimir Korolev on 14.05.2022.
//  Copyright © 2022 VladimirBrejcha. All rights reserved.
//

import UIKit
import DomainLayer

final class RootCoordinator {

  private let useCases: UseCases
  private let navigationController: UINavigationController

  init(useCases: UseCases,
       navigationController: UINavigationController
  ) {
    self.useCases = useCases
    self.navigationController = navigationController
  }

  func run() {
    navigationController.setViewControllers(
      rootControllers,
      animated: true
    )
  }

  // MARK: - rootControllers

  private var rootControllers: [UIViewController] {
    var controllers: [UIViewController] = [tabBar]

    // if is sleeping
    if let activeSleepEndDate = useCases.manageActiveSleep.alarmAt {
      let minSinceWakeUp = Date().timeIntervalSince(activeSleepEndDate) / 60
      switch minSinceWakeUp {
      case ..<0:
        controllers.append(sleep(params: activeSleepEndDate))
      case 0...30:
        controllers.append(alarming)
      default:
        // if expected wake up happened more than 30 minutes ago, discard sleep
        useCases.manageActiveSleep.endSleep()
      }
    }

    else if !useCases.manageOnboardingCompleted.isCompleted {
      controllers.append(onboarding)
    }

    return controllers
  }

  // MARK: - All View Controllers

  private var tabBar: TabBarController {
    TabBarController(
      items: [schedule, today, settings],
      selectedIndex: 1
    )
  }

  private var onboarding: Onboarding.Controller {
    Onboarding.Controller(
      deps: useCases,
      params: Onboarding.defaultParams,
      out: { [unowned nc = navigationController] command in
        switch command {
        case .finish:
          nc.popViewController(animated: true)
        }
      })
  }

  private var settings: Settings.Controller {
    .init(deps: useCases) { [self, unowned nc = navigationController] command in
      switch command {
      case .editSchedule(let schedule):
        nc.pushViewController(editSchedule(params: schedule), animated: true)
      case .adjustSchedule(let schedule):
        nc.present(
          adjustSchedule((schedule, nil)),
          with: .fullScreen
        )
      case .showOnboarding:
        nc.pushViewController(
          onboarding,
          animated: true
        )
      case .showAbout:
        nc.present(about, with: .modal)
      case .showRefreshSuntime:
        nc.present(refreshSunTimes, with: .modal)
      }
    }
  }

  private func editSchedule(params: EditSchedule.Controller.Params) -> EditSchedule.Controller {
    .init(deps: useCases, params: params) { [unowned nc = navigationController] command in
      switch command {
      case .finish:
        nc.popViewController(animated: true)
      }
    }
  }

  private var schedule: SchedulePage.Controller {
    .init(deps: useCases) { [self, unowned nc = navigationController] command in
      switch command {
      case .createSchedule:
        nc.present(
          createSchedule,
          with: .modal
        )
      }
    }
  }

  private var createSchedule: CreateScheduleViewController {
    CreateScheduleAssembler().assemble(deps: useCases)
  }

  private func keepAppOpened(
    params: KeepAppOpenedSuggestion.Controller.Params
  ) -> KeepAppOpenedSuggestion.Controller {
    .init(params: params) { [unowned nc = navigationController] command in
      switch command {
      case .finish(let completion):
        nc.dismiss(
          animated: true,
          completion: completion
        )
      }
    }
  }
  
  private var prepareToSleep: PrepareToSleepViewController {
    let controller = Storyboard.sleep.instantiateViewController(of: PrepareToSleepViewController.self)
    controller.deps = useCases
    controller.out = { [self, unowned nc = navigationController] command in
      switch command {
      case .showKeepAppOpenedSuggestion(let completion):
        nc.present(
          keepAppOpened(params: completion),
          with: .fullScreen
        )
      case .finish:
        nc.popToRootViewController(animated: true)
      case .showSleep(let wakeUp):
        nc.replaceAllOnTopOfRoot(
          with: sleep(params: wakeUp)
        )
      }
    }
    return controller
  }

  private var today: Today.Controller {
    .init(
      deps: useCases,
      params: Days.Controller(deps: useCases)
    ) { [self, unowned nc = navigationController] command in
      switch command {
      case .prepareToSleep:
        nc.pushViewController(
          prepareToSleep,
          animated: true
        )
      case let .adjustSchedule(currentSchedule, completion):
        nc.present(
          adjustSchedule((currentSchedule, nil), completion: completion),
          with: .modal
        )
      }
    }
  }

  private var refreshSunTimes: RefreshSunTimesViewController {
    .init(deps: useCases) { [unowned nc = navigationController] command in
      switch command {
      case .finish:
        nc.dismiss(animated: true)
      }
    }
  }

  private func sleep(params: SleepViewController.Params) -> SleepViewController {
    .init(deps: useCases, params: params) { [self, unowned nc = navigationController] command in
      switch command {
      case .showKeepAppOpenedSuggestion:
        nc.present(
          keepAppOpened(params: nil),
          with: .modal
        )
      case .showAfterSleep:
        nc.replaceAllOnTopOfRoot(
          with: afterSleep
        )
      case .showAlarming:
        nc.replaceAllOnTopOfRoot(
          with: alarming
        )
      }
    }
  }

  private var alarming: AlarmingViewController {
    .init(deps: useCases) { [self, unowned nc = navigationController] command in
      switch command {
      case .alarmStopped:
        nc.replaceAllOnTopOfRoot(
          with: afterSleep
        )
      case .alarmSnoozed(let newAlarmTime):
        nc.replaceAllOnTopOfRoot(
          with: sleep(params: newAlarmTime)
        )
      }
    }
  }

  private var afterSleep: AfterSleepViewController {
    .init(deps: useCases) { [self, unowned nc = navigationController] command in
      switch command {
      case .finish:
        nc.popToRootViewController(
          animated: true
        )
      case let .adjustSchedule(currentSchedule, toBed):
        nc.present(
          adjustSchedule((currentSchedule: currentSchedule, toBed: toBed)),
          with: .modal
        )
      }
    }
  }

  private func adjustSchedule(
    _ params: AdjustScheduleViewController.Params,
    completion: ((Bool) -> Void)? = nil
  ) -> AdjustScheduleViewController {
    .init(deps: useCases, params: params) { [unowned nc = navigationController] command in
      switch command {
      case .cancelAdjustment:
        nc.dismiss(animated: true, completion: {
          completion?(false)
        })
      case .adjustmentCompleted:
        nc.dismiss(animated: true, completion: {
          completion?(true)
        })
      }
    }
  }

  private var about: AboutViewController {
    .init(deps: useCases)
  }
}
