//
//  SettingsViewController.swift
//  Rise
//
//  Created by Vladimir Korolev on 03/06/2019.
//  Copyright © 2019-2020 VladimirBrejcha. All rights reserved.
//

import UIKit
import Core

extension Settings {

  final class Controller: UIViewController, ViewController {

    enum OutCommand {
      case editSchedule(Schedule)
      case adjustSchedule(Schedule)
      case showOnboarding
      case showAbout
      case showRefreshSuntime
    }

    typealias Deps = HasGetScheduleUseCase
    typealias View = Settings.View

    private let deps: Deps
    private let out: Out

    override var tabBarItem: UITabBarItem! {
      get { _tabBarItem }
      set { _tabBarItem = newValue }
    }

    private lazy var _tabBarItem: UITabBarItem = .withSystemIcons(
      normal: "gearshape",
      selected: "gearshape.fill"
    )

    private var schedule: Schedule? {
      deps.getSchedule.today()
    }

    init(deps: Deps, out: @escaping Out) {
      self.deps = deps
      self.out = out
      super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
      fatalError("This class does not support NSCoder")
    }

    override func loadView() {
      super.loadView()

      self.view = View(
        selectionHandler: { [unowned self] identifier in

          rootView.deselectAll()

          switch identifier {
          case .editSchedule:
            if let schedule = schedule {
              out(.editSchedule(schedule))
            } else {
              assertionFailure("Attempted to present editSchedule without schedule")
            }
          case .adjustBedTime:
            if let schedule = schedule {
              out(.adjustSchedule(schedule))
            } else {
              assertionFailure("Attempted to present editSchedule without schedule")
            }
          case .onboarding:
            out(.showOnboarding)
          case .about:
            out(.showAbout)
          case .refreshSuntime:
            out(.showRefreshSuntime)
          }
        }
      )
    }

    override func viewWillAppear(_ animated: Bool) {
      super.viewWillAppear(animated)
      rootView.reconfigure(
        with: Settings.prepareModels(hasSchedule: schedule != nil)
      )
    }
  }
}

