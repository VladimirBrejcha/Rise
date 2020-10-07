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
    
    // MARK: - CollectionDataSource
    private typealias CellConfigurator = CollectionCellConfigurator<DaysCollectionCell, DaysCollectionCell.Model>
    private var collectionDataSource: CollectionDataSource!
    private var cellModels: [DaysCollectionCell.Model] {
        get {
            if let dataSource = collectionDataSource {
                return dataSource
                    .items
                    .compactMap { $0 as? CellConfigurator }
                    .map { $0.model }
            } else {
                return []
            }
        }
        set {
            collectionDataSource?.items = newValue.map { CellConfigurator(model: $0) }
        }
    }
    
    // MARK: - State
    private struct State {
        var sunTimeState: LoadState<[SunTime]>
        var planState: LoadState<RisePlan>
        
        enum LoadState<Data: Equatable>: Equatable {
            case loading
            case loaded (data: Data)
            case failed
        }
    }
    private var state: State = State(sunTimeState: .loading, planState: .failed) {
        didSet {
            DispatchQueue.main.async {
                if self.viewIsVisible {
                    self.applyNewState(self.state, to: oldValue)
                } else {
                    self.performOnDidAppear.append {
                        self.applyNewState(self.state, to: oldValue)
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
        
        collectionDataSource = CollectionDataSource(
            items: [
                CellConfigurator(model: emptySunCellModel),
                CellConfigurator(model: emptyPlanCellModel),
                CellConfigurator(model: emptySunCellModel),
                CellConfigurator(model: emptyPlanCellModel),
                CellConfigurator(model: emptySunCellModel),
                CellConfigurator(model: emptyPlanCellModel)
            ]
        )
        
        todayView.configure(
            dataSource: TodayView.DataSource(
                collection: collectionDataSource,
                timeUntilSleep:  { [weak self] in
                    self?.floatingLabelModel ?? FloatingLabel.Model(text: "", alpha: 0)
                }
            ),
            handlers: TodayView.Handlers(
                sleepHandler: { [weak self] in
                    self?.present(
                        AnimatedTransitionNavigationController(rootViewController: Story.prepareToSleep()),
                        with: .fullScreen
                    )
                }
            )
        )
        
        if let plan = try? getPlan() {
            state = State(sunTimeState: .loading, planState: .loaded(data: plan))
        } else {
            state = State(sunTimeState: .loading, planState: .failed)
        }
        
        observePlan.observe { [weak self] plan in
            if let plan = plan {
                self?.state.planState = .loaded(data: plan)
            } else {
                self?.state.planState = .failed
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
    
    // MARK: - Private -
    private func makeTabBar(visible: Bool) {
        animate {
            self.tabBarController?.tabBar.alpha = visible ? 1 : 0
        }
    }
    
    // MARK: - Apply states
    private func applyNewState(_ state: State, to oldState: State) {
        if oldState.sunTimeState != state.sunTimeState {
            applySunTimeState(state.sunTimeState)
        }
        if oldState.planState != state.planState {
            applyPlanState(state.planState)
        }
    }
    
    private func applySunTimeState(_ state: State.LoadState<[SunTime]>) {
        var newStates: [DaysCollectionCell.State]?
        
        switch state {
        case .loading:
            newStates = [.loading, .loading, .loading]
        case .loaded(let sunTimes):
            newStates = sunTimes.map {
                .showingContent(left: $0.sunrise.HHmmString, right: $0.sunset.HHmmString)
            }
        case .failed:
            newStates = [.showingError(error: "Failed to load data"),
                         .showingError(error: "Failed to load data"),
                         .showingError(error: "Failed to load data")]
        }
        
        guard let states = newStates else { return }
        refreshItems(with: states, using: \.isEven) // odd indexes are for planViews
    }
    
    private func applyPlanState(_ state: State.LoadState<RisePlan>) {
        var newStates: [DaysCollectionCell.State]?
        switch state {
        case .loading:
            newStates = [.loading, .loading, .loading]
        case .loaded(let plan):
            let datesArray: [NoonedDay] = [.yesterday, .today, .tomorrow]
            
            newStates = []
            
            for date in datesArray {
                if let dailyTime = try? getDailyTime(for: plan, date: date.date) {
                    newStates?.append(
                        .showingContent(
                            left: dailyTime.wake.HHmmString,
                            right: dailyTime.sleep.HHmmString
                        )
                    )
                } else {
                    newStates?.append(.showingInfo(info: "No plan for the day"))
                }
            }
            
        case .failed:
            newStates = [.showingInfo(info: "You don't have a plan yet"),
                         .showingInfo(info: "You don't have a plan yet"),
                         .showingInfo(info: "You don't have a plan yet")]
        }
        
        guard let states = newStates else { return }
        refreshItems(with: states, using: \.isOdd) // even indexes are for sunViews
    }
    
    // MARK: - Refresh items
    private func refreshItems(with states: [DaysCollectionCell.State], using predicate: (Int) -> Bool) {
        var itemsToReload = [Int]()
        
        var stateCounter = 0
        for index in cellModels.indices {
            if predicate(index) && states.indices.contains(stateCounter) {
                cellModels[index].state = states[stateCounter]
                itemsToReload.append(index)
                stateCounter += 1
            }
        }
        
        todayView.reloadItems(at: itemsToReload)
    }
    
    // MARK: - Refresh sun times
    private func refreshSunTimes() {
        getSunTime(numberOfDays: 3, since: NoonedDay.yesterday.date) { [weak self] result in
            if case .success (let sunTimes) = result {
                self?.state.sunTimeState = .loaded(data: sunTimes)
            }
            if case .failure (let error) = result {
                log(.error, with: error.localizedDescription)
                self?.state.sunTimeState = .failed
            }
        }
    }

    // MARK: - Repeat handler
    private func repeatButtonPressed(on cell: DaysCollectionCell) {
        guard let index = todayView.getIndexOf(cell: cell) else {
            log(.warning, with: "repeatButtonPressed called, but index of the cell was nil")
            return
        }
        
        guard index.isEven else {
            log(.warning, with: "repeatButtonPressed called, but index was odd")
            return
        }
        
        state.sunTimeState = .loading
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
    private var emptySunCellModel: DaysCollectionCell.Model {
        DaysCollectionCell.Model(
            state: .loading,
            imageName: (left: "sunrise", right: "sunset"),
            repeatHandler: { [weak self] cell in
                self?.repeatButtonPressed(on: cell)
            }
        )
    }
    
    private var emptyPlanCellModel: DaysCollectionCell.Model {
        DaysCollectionCell.Model(
            state: .showingInfo(info: "You don't have a plan yet"),
            imageName: (left: "wakeup", right: "bed"),
            repeatHandler: { [weak self] cell in
                self?.repeatButtonPressed(on: cell)
            }
        )
    }
}
