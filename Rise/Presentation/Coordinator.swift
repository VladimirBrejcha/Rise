//
//  Coordinator.swift
//  Rise
//
//  Created by Vladimir Korolev on 14.05.2022.
//  Copyright © 2022 VladimirBrejcha. All rights reserved.
//

import UIKit

final class RootCoordinator {

  typealias Dependencies = UseCases

  private let deps: Dependencies
  private let navigationController: UINavigationController

  init(deps: Dependencies, navigationController: UINavigationController) {
    self.deps = deps
    self.navigationController = navigationController
  }

  func run() {
    navigationController.setViewControllers(
      [tabBar, onboarding],
      animated: true
    )
  }

  // MARK: - ViewControllers

  private var tabBar: TabBarController {
    TabBarController(
      items: [schedule, today, settings],
      selectedIndex: 1
    )
  }

  private var onboarding: Onboarding.Controller {
    Onboarding.Controller(
      deps: deps,
      params: Onboarding.defaultParams,
      out: { [unowned nc = navigationController] command in
        nc.popViewController(animated: true)
    })
  }

  private var settings: Settings.Controller {
    .init(deps: deps) { [self, unowned nc = navigationController] command in
      switch command {
      case .editSchedule(let schedule):
        nc.pushViewController(editSchedule(params: schedule), animated: true)
      case .adjustSchedule(let schedule):
        nc.present(
          Story.adjustSchedule(
            currentSchedule: schedule
          )(),
          with: .fullScreen
        )
      case .showOnboarding:
        nc.pushViewController(
          onboarding,
          animated: true
        )
      case .showAbout:
        nc.present(Story.about(), with: .modal)
      case .showRefreshSuntime:
        nc.present(refreshSunTimes, with: .modal)
      }
    }
  }

  private func editSchedule(params: EditSchedule.Controller.Params) -> EditSchedule.Controller {
    .init(deps: deps, params: params) { [unowned nc = navigationController] command in
      switch command {
      case .finish:
        nc.popViewController(animated: true)
      }
    }
  }

  private var schedule: SchedulePage.Controller {
    .init(deps: deps) { [self, unowned nc = navigationController] command in
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
    CreateScheduleAssembler().assemble()
  }

  func keepAppOpened(
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
    controller.deps = deps
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
          with: Story.sleep(alarmTime: wakeUp)()
        )
      }
    }
    return controller
  }

  private var today: Today.Controller {
    .init(
      deps: deps,
      params: Days.Controller(deps: deps)
    ) { [self, unowned nc = navigationController] command in
      switch command {
      case .prepareToSleep:
        nc.pushViewController(
          prepareToSleep,
          animated: true
        )
      case let .adjustSchedule(currentSchedule, completion):
        nc.present(
          Story.adjustSchedule(
            currentSchedule: currentSchedule,
            completion: completion
          )(),
          with: .modal
        )
      }
    }
  }

  var refreshSunTimes: RefreshSunTimesViewController {
    .init(deps: deps) { [unowned nc = navigationController] command in
      switch command {
      case .finish:
        nc.dismiss(animated: true)
      }
    }
  }

  func sleep(params: SleepViewController.Params) -> SleepViewController {
    .init(deps: deps, params: params) { [self, unowned nc = navigationController] command in
      switch command {
      case .showKeepAppOpenedSuggestion:
        nc.present(
          keepAppOpened(params: nil),
          with: .modal
        )
      case .showAfterSleep:
        nc.replaceAllOnTopOfRoot(
          with: Story.afterSleep()
        )
      case .showAlarming:
        nc.replaceAllOnTopOfRoot(
          with: Story.alarming()
        )
      }
    }
  }
}
