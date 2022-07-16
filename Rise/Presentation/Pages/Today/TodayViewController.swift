//
//  TodayViewController.swift
//  Rise
//
//  Created by Vladimir Korolev on 03/06/2019.
//  Copyright © 2019-2020 VladimirBrejcha. All rights reserved.
//

import UIKit
import Core
import DomainLayer
import Localization

extension Today {

  final class Controller: UIViewController, ViewController {

    enum OutCommand {
      case prepareToSleep
      case adjustSchedule(currentSchedule: Schedule, completion: (Bool) -> Void)
    }
    typealias Deps = HasGetSchedule & HasAdjustSchedule
    typealias Params = Days.Controller
    typealias View = Today.View

    private let deps: Deps
    private let out: Out
    private let daysViewController: Days.Controller
    private var todaySchedule: Schedule?

    override var tabBarItem: UITabBarItem! {
      get { _tabBarItem }
      set { _tabBarItem = newValue }
    }

    private lazy var _tabBarItem: UITabBarItem = .withSystemIcons(
      normal: "moon.stars",
      selected: "moon.stars.fill",
      size: 25
    )

    init(deps: Deps, params: Params, out: @escaping Out) {
      self.deps = deps
      self.daysViewController = params
      self.out = out
      super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
      super.loadView()
      self.view = View(
        timeUntilSleepDataSource: { [weak self] in
          self?.floatingLabelModel ?? .empty
        },
        sleepHandler: { [weak self] in
          self?.out(.prepareToSleep)
        },
        showAdjustSchedule: deps.adjustSchedule.mightNeedAdjustment,
        adjustScheduleHandler: { [weak self] in
          guard let todaySchedule = self?.todaySchedule else {
            return
          }
          self?.out(.adjustSchedule(
            currentSchedule: todaySchedule,
            completion: { adjusted in
              if adjusted {
                self?.daysViewController.refreshSchedule()
              }
              self?.rootView.allowAdjustSchedule(false)
            }
          ))
        },
        daysView: daysViewController.rootView
      )
    }

    override func viewDidLoad() {
      super.viewDidLoad()

      addChild(daysViewController)
      daysViewController.didMove(toParent: self)
    }

    override func viewWillAppear(_ animated: Bool) {
      super.viewWillAppear(animated)

      todaySchedule = deps.getSchedule.today()
    }

    // MARK: - Floating label model

    private var floatingLabelModel: FloatingLabel.Model {
      guard let todaySchedule = todaySchedule else {
        return .empty
      }

      guard let minutesUntilSleep = calendar
        .dateComponents(
          [.minute],
          from: Date(),
          to: todaySchedule.toBed
        ).minute
      else {
        return .empty
      }

      let alpha: Float = 0.85

      switch minutesUntilSleep {
      case ...0:
        return .init(
          text: Text.itsTimeToSleep,
          alpha: alpha
        )
      case 1..<10:
        return .init(
          text: Text.sleepInJustAFew(minutesUntilSleep.HHmmString),
          alpha: alpha
        )
      case 10...(60 * 5):
        return .init(
          text: Text.sleepIsScheduledIn(minutesUntilSleep.HHmmString),
          alpha: alpha
        )
      default:
        return .empty
      }
    }
  }
}

fileprivate extension FloatingLabel.Model {
  static var empty = FloatingLabel.Model(text: "", alpha: 0)
}
