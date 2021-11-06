//
//  TodayViewController.swift
//  Rise
//
//  Created by Vladimir Korolev on 03/06/2019.
//  Copyright © 2019-2020 VladimirBrejcha. All rights reserved.
//

import UIKit

final class TodayViewController: UIViewController, PropertyAnimatable {

    private var todayView: TodayView { view as! TodayView }
    private let daysViewController = Story.days() as! DaysViewController

    private let getSchedule: GetSchedule

    private var todaySchedule: Schedule?

    var propertyAnimationDuration: Double { 0.15 }
    // MARK: - LifeCycle

    init(getSchedule: GetSchedule) {
        self.getSchedule = getSchedule

        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("This class does not support NSCoder")
    }

    override func loadView() {
        super.loadView()
        self.view = TodayView(
            timeUntilSleepDataSource: { [weak self] in
                self?.floatingLabelModel ?? .empty
            },
            sleepHandler: { [weak self] in
                self?.present(
                    AnimatedTransitionNavigationController(
                        rootViewController: Story.prepareToSleep()
                    ),
                    with: .fullScreen
                )
            },
            daysView: daysViewController.daysView
        )
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        addChild(daysViewController)
        daysViewController.didMove(toParent: self)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.todaySchedule = getSchedule.today()
    }

    // MARK: - Floating label model
    
    private var floatingLabelModel: FloatingLabel.Model {
        guard let todaySchedule = todaySchedule else {
            return .empty
        }

        guard let minutesUntilSleep = calendar.dateComponents(
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

    // MARK: - Utils

    private func makeTabBar(visible: Bool) {
        animate {
            self.tabBarController?.tabBar.alpha = visible ? 1 : 0
        }
    }
}

fileprivate extension FloatingLabel.Model {
    static var empty = FloatingLabel.Model(text: "", alpha: 0)
}
