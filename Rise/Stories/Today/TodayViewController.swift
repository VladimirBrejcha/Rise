//
//  TodayViewController.swift
//  Rise
//
//  Created by Vladimir Korolev on 03/06/2019.
//  Copyright © 2019-2020 VladimirBrejcha. All rights reserved.
//

import UIKit

final class TodayViewController: UIViewController, PropertyAnimatable {
    // MARK: - PropertyAnimatable
    var propertyAnimationDuration: Double { 0.15 }
    
    @IBOutlet private var todayView: TodayView!
    
    var getSunTime: GetSunTime! // DI
    var getPlan: GetPlan! // DI
    var observePlan: ObservePlan! // DI
    var getDailyTime: GetDailyTime! // DI
    var confirmPlan: ConfirmPlan! // DI
    
    // MARK: - State
    fileprivate struct State: Equatable {
        let sunTimeState: LoadState<[SunTime]>
        let planState: LoadState<RisePlan>
        
        enum LoadState<Data: Equatable>: Equatable {
            case loading
            case loaded (data: Data)
            case failed
        }
    }
    private var state: State = State(sunTimeState: .loading, planState: .failed) {
        didSet {
            DispatchQueue.main.async {
                if self.state == oldValue { return }
                if self.viewIsVisible {
                    self.applySnapshot()
                } else {
                    self.performOnDidAppear.append {
                        self.applySnapshot()
                    }
                }
            }
        }
    }
    
    private var performOnDidAppear: [() -> Void] = []
    private var viewIsVisible: Bool = false
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        
        if let plan = try? getPlan() {
            state = State(sunTimeState: .loading, planState: .loaded(data: plan))
        } else {
            state = State(sunTimeState: .loading, planState: .failed)
        }
        
        observePlan.observe { [weak self] plan in
            guard let self = self else { return }
            if let plan = plan {
                self.state = self.state.changing { $0.planState = .loaded(data: plan) }
            } else {
                self.state = self.state.changing { $0.planState = .failed }
            }
        }

        refreshSunTimes()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        viewIsVisible = true
        
        if performOnDidAppear.isNotEmpty {
            performOnDidAppear.forEach { $0() }
            performOnDidAppear.removeAll()
        }
        
        if let confirmed = try? confirmPlan.checkIfConfirmed() {
            makeTabBar(visible: confirmed)
            if !confirmed {
                present(Story.confirmation(), with: .overContext)
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        viewIsVisible = false
    }

    func applySnapshot(animatingDifferences: Bool = false) {
        var snapshot = TodayView.Snapshot()
        snapshot.appendSections([.sun, .plan])
        snapshot.appendItems(applySunTimeState(state.sunTimeState), toSection: .sun)
        snapshot.appendItems(applyPlanState(state.planState), toSection: .plan)
        todayView.applySnapshot(snapshot)
    }
    
    // MARK: - Private -
    private func makeTabBar(visible: Bool) {
        animate {
            self.tabBarController?.tabBar.alpha = visible ? 1 : 0
        }
    }
    
    // MARK: - Apply states
    private func applySunTimeState(_ state: State.LoadState<[SunTime]>) -> [DaysCollectionView.Item.Model] {
        if todayView.snapshot.numberOfSections == 0 {
            return apply(state: state, on: defaultSunModels)
        } else {
            return apply(state: state, on: todayView.snapshot.itemIdentifiers(inSection: .sun))
        }
    }

    private func apply(
        state: State.LoadState<[SunTime]>,
        on snapshot: [DaysCollectionView.Item.Model]
    ) -> [DaysCollectionView.Item.Model] {
        var result = snapshot
        switch state {
        case .loading:
            result = snapshot.map { $0.changing { $0.state = .loading } }
        case .loaded(let sunTimes):
            for (index, value) in sunTimes.enumerated() {
                result[index] = snapshot[index].changing {
                    $0.state = .showingContent(left: value.sunrise.HHmmString, right: value.sunset.HHmmString)
                }
            }
        case .failed:
            result = snapshot.map { $0.changing { $0.state = .showingError(error: "Failed to load data") } }
        }
        return result
    }
    
    private func applyPlanState(_ state: State.LoadState<RisePlan>) -> [DaysCollectionView.Item.Model] {
        if todayView.snapshot.numberOfSections == 0 {
            return apply(state: state, on: defaultPlanModels)
        } else {
            return apply(state: state, on: todayView.snapshot.itemIdentifiers(inSection: .plan))
        }
    }

    private func apply(
        state: State.LoadState<RisePlan>,
        on snapshot: [DaysCollectionView.Item.Model]
    ) -> [DaysCollectionView.Item.Model] {
        var result = snapshot
        switch state {
        case .loading:
            result = snapshot.map { $0.changing { $0.state = .loading } }
        case .loaded(let plan):
            let datesArray: [NoonedDay] = [.yesterday, .today, .tomorrow]
            for (index, value) in datesArray.enumerated() {
                if let dailyTime = try? getDailyTime(for: plan, date: value.date) {
                    result[index] = snapshot[index].changing {
                        $0.state = .showingContent(left: dailyTime.wake.HHmmString, right: dailyTime.sleep.HHmmString)
                    }
                } else {
                    result[index] = snapshot[index].changing {
                        $0.state = .showingInfo(info: "No plan for the day")
                    }
                }
            }
        case .failed:
            result = snapshot.map { $0.changing { $0.state = .showingInfo(info: "You don't have a plan yet") } }
        }
        return result
    }

    // MARK: - Refresh sun times
    private func refreshSunTimes() {
        getSunTime(numberOfDays: 3, since: NoonedDay.yesterday.date) { [weak self] result in
            guard let self = self else { return }
            if case .success (let sunTimes) = result {
                self.state = self.state.changing{ $0.sunTimeState = .loaded(data: sunTimes) }
            }
            if case .failure = result {
                self.state = self.state.changing{ $0.sunTimeState = .failed }
            }
        }
    }

    // MARK: - Repeat handler
    private func repeatButtonPressed(on cell: DaysCollectionCell) {
        state = state.changing{ $0.sunTimeState = .loading }
        refreshSunTimes()
    }
    
    // MARK: - Floating label model
    private var floatingLabelModel: FloatingLabel.Model {
        guard case .loaded (let plan) = state.planState else {
            return FloatingLabel.Model(text: "", alpha: 0)
        }
        
        if plan.paused {
            return FloatingLabel.Model(text: "Your personal plan is on pause", alpha: 0.85)
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
    
    // MARK: - Default cells
    private var defaultSunModels: [DaysCollectionView.Item.Model] {
        [
            DaysCollectionCell.Model(
                state: .loading,
                imageName: (left: "sunrise", right: "sunset"),
                repeatHandler: repeatButtonPressed,
                id: "Sun.yesterday"
            ),
            DaysCollectionCell.Model(
                state: .loading,
                imageName: (left: "sunrise", right: "sunset"),
                repeatHandler: repeatButtonPressed,
                id: "Sun.today"
            ),
            DaysCollectionCell.Model(
                state: .loading,
                imageName: (left: "sunrise", right: "sunset"),
                repeatHandler: repeatButtonPressed,
                id: "Sun.tomorrow"
            )
        ]
    }

    private var defaultPlanModels: [DaysCollectionView.Item.Model] {
        [
            DaysCollectionCell.Model(
                state: .showingInfo(info: "You don't have a plan yet"),
                imageName: (left: "wakeup", right: "bed"),
                repeatHandler: repeatButtonPressed,
                id: "Plan.yesterday"
            ),
            DaysCollectionCell.Model(
                state: .showingInfo(info: "You don't have a plan yet"),
                imageName: (left: "wakeup", right: "bed"),
                repeatHandler: repeatButtonPressed,
                id: "Plan.today"
            ),
            DaysCollectionCell.Model(
                state: .showingInfo(info: "You don't have a plan yet"),
                imageName: (left: "wakeup", right: "bed"),
                repeatHandler: repeatButtonPressed,
                id: "Plan.tomorrow"
            )
        ]
    }
}

extension TodayViewController.State: Changeable {
    init(copy: ChangeableWrapper<TodayViewController.State>) {
        self.init(sunTimeState: copy.sunTimeState, planState: copy.planState)
    }
}
