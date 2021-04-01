//
//  TodayViewController.swift
//  Rise
//
//  Created by Vladimir Korolev on 03/06/2019.
//  Copyright © 2019-2020 VladimirBrejcha. All rights reserved.
//

import UIKit

final class TodayViewController: UIViewController, Statefull, PropertyAnimatable {
    @IBOutlet private var todayView: TodayView!
    private var daysViewController: DaysViewController! // lateinit

    var getPlan: GetPlan! // DI
    var observePlan: ObservePlan! // DI
    var getDailyTime: GetDailyTime! // DI
    var confirmPlan: ConfirmPlan! // DI

    // MARK: - PropertyAnimatable
    var propertyAnimationDuration: Double { 0.15 }
    
    // MARK: - Statefull -
    struct State: Equatable {
        let plan: RisePlan?
    }

    private(set) var state: State?

    func setState(_ state: State) {
        self.state = state
    }
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

        let width = view.bounds.width - 40
        let height = width
        let y = (view.bounds.height - height) / 2

        daysViewController = Story.days(
            frame: CGRect(x: 20, y: y, width: width, height: height)
        )() as? DaysViewController

        addChild(daysViewController)
        todayView.addSubview(daysViewController.view)

        daysViewController.didMove(toParent: self)
        
        todayView.configure(
            timeUntilSleepDataSource: { [weak self] in
                self?.floatingLabelModel ?? FloatingLabel.Model(text: "", alpha: 0)
            },
            sleepHandler: { [weak self] in
                self?.present(
                    AnimatedTransitionNavigationController(rootViewController: Story.prepareToSleep()),
                    with: .fullScreen
                )
            }
        )

        setState(State(plan: try? getPlan()))

        observePlan.observe { [weak self] plan in
            self?.setState(State(plan: plan))
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let confirmed = try? confirmPlan.checkIfConfirmed() {
            makeTabBar(visible: confirmed)
            if !confirmed {
                present(Story.confirmation(), with: .overContext)
            }
        }
    }

    // MARK: - Floating label model
    private var floatingLabelModel: FloatingLabel.Model {
        guard let plan = state?.plan else {
            return FloatingLabel.Model(text: "", alpha: 0)
        }
        
        if plan.paused {
            return FloatingLabel.Model(text: "Personal plan is paused", alpha: 0.85)
        }
        
        guard let todayDailyTime = try? getDailyTime(for: plan, date: NoonedDay.today.date),
              let minutesUntilSleep = calendar.dateComponents(
                [.minute],
                from: Date(),
                to: todayDailyTime.sleep
              ).minute else {
            return FloatingLabel.Model(text: "", alpha: 0)
        }
        
        let minutesInDay: Float = 24 * 60
        let sleepDuration = plan.sleepDurationSec
        let alphaMin: Float = 0.3
        let alphaMax: Float = 0.85
        
        if Float(minutesUntilSleep) >= minutesInDay - Float(sleepDuration / 60) {
            return FloatingLabel.Model(text: "It's time to sleep!", alpha: alphaMax)
        }
        
        var alpha: Float = (minutesInDay - Float(minutesUntilSleep)) / minutesInDay
        if alpha < alphaMin { alpha = alphaMin }
        if alpha > alphaMax { alpha = alphaMax }
        
        return FloatingLabel.Model(text: "Sleep planned in \(minutesUntilSleep.HHmmString)", alpha: alpha)
    }

    private func makeTabBar(visible: Bool) {
        animate {
            self.tabBarController?.tabBar.alpha = visible ? 1 : 0
        }
    }
}
