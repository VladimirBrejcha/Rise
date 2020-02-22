//
//  MainScreenPresenter.swift
//  Rise
//
//  Created by Владимир Королев on 14.10.2019.
//  Copyright © 2019 VladimirBrejcha. All rights reserved.
//

import Foundation

typealias TodayCollectionCellConfigurator = CollectionCellConfigurator<DaysCollectionCell, DaysCollectionCellModel>

final class TodayStoryPresenter: TodayStoryViewOutput {
    private unowned var view: TodayStoryViewInput
    
    private let getSunTime: GetSunTime
    private let getPlan: GetPlan
    private let observePlan: ObservePlan
    
    private var personalPlan: PersonalPlan? {
        return getPlan.execute()
    }
    
    private var collectionDataSource: CollectionDataSource?
    
    private var cellModels: [DaysCollectionCellModel] {
        get {
            guard let dataSource = collectionDataSource
                else {
                    return []
            }
            return dataSource
                .items
                .compactMap { $0 as? TodayCollectionCellConfigurator }
                .map { $0.model }
            
        }
        set {
            guard let dataSource = collectionDataSource
                else {
                    return
            }
            dataSource.items
                = newValue
                    .map { TodayCollectionCellConfigurator(model: $0) }
        }
    }
    
    required init(
        view: TodayStoryViewInput,
        getSunTime: GetSunTime,
        getPlan: GetPlan,
        observePlan: ObservePlan
    ) {
        self.view = view
        self.getSunTime = getSunTime
        self.getPlan = getPlan
        self.observePlan = observePlan
    }
    
    // MARK: - TodayStoryViewOutput -
    func viewDidLoad() {
        collectionDataSource = CollectionDataSource(items: [
            TodayCollectionCellConfigurator(model: makeEmptySunCellModel()),
            TodayCollectionCellConfigurator(model: makeEmptyPlanCellModel()),
            TodayCollectionCellConfigurator(model: makeEmptySunCellModel()),
            TodayCollectionCellConfigurator(model: makeEmptyPlanCellModel()),
            TodayCollectionCellConfigurator(model: makeEmptySunCellModel()),
            TodayCollectionCellConfigurator(model: makeEmptyPlanCellModel())
        ])

        view.setupCollectionView(with: collectionDataSource!)
        updatePlanView(with: getPlan.execute())
        requestSunTime()

        observePlan.execute({ [weak self] plan in
            self?.view.setupTimeToSleepLabel(dataSource: self?.floatingLabelDataSource)
            self?.updatePlanView(with: plan)
        })
    }
    
    func viewWillAppear() {
        view.makeTabBar(visible: true)
    }
    
    func viewDidAppear() {
        guard let plan = personalPlan else { return }
        
        view.setupTimeToSleepLabel(dataSource: floatingLabelDataSource)
        
        if !PersonalPlanHelper.isConfirmed(for: .yesterday, plan: plan) {
            view.makeTabBar(visible: false)
            view.present(controller: Story.confirmation.configure())
        }
    }
    
    // MARK: - Private Methods -
    private func requestSunTime() {
        getSunTime.execute((numberOfDays: 3, day: Day.yesterday.date)) { [weak self] result in
            guard let self = self else { return }
            if case .success (let sunTime) = result { self.updateSunTimeView(with: sunTime) }
            if case .failure (let error) = result {
                log(.error, with: error.localizedDescription)
                self.updateSunTimeView(with: nil)
            }
        }
    }
    
    private func updateSunTimeView(with sunModelArray: [DailySunTime]?) {
        if let models = sunModelArray {
            for index in cellModels.enumerated() {
                if index.offset % 2 == 0 {
                    let sunTime = models[(index.offset) / 2]
                    cellModels[index.offset] = DaysCollectionCellModel(
                        state: .showingContent(left: sunTime.sunrise.HHmmString, right: sunTime.sunset.HHmmString),
                        imageName: (left: "sunrise", right: "sunset"),
                        repeatButtonHandler: repeatButtonPressed(on:)
                    )
                }
            }
        } else {
            for index in cellModels.enumerated() {
                if index.offset % 2 == 0 {
                    cellModels[index.offset] = DaysCollectionCellModel(
                        state: .showingError(error: "Failed to load data"),
                        imageName: (left: "sunrise", right: "sunset"),
                        repeatButtonHandler: repeatButtonPressed(on:)
                    )
                }
            }
        }
        DispatchQueue.main.async {
            self.view.refreshCollectionView()
        }
    }
    
    private func updatePlanView(with plan: PersonalPlan?) {
        guard let plan = plan
            else {
                return
        }
        
        let datesArray: [Day] = [.yesterday, .today, .tomorrow]
        
        for index in cellModels.enumerated() {
            if index.offset % 2 != 0 {
                if let dailyTime = PersonalPlanHelper.getDailyTime(for: plan,
                                                                   and: datesArray[(index.offset / 2)].date) {
                    cellModels[index.offset] = DaysCollectionCellModel(
                        state: .showingContent(left: dailyTime.wake.HHmmString, right: dailyTime.sleep.HHmmString),
                        imageName: (left: "wakeup", right: "bed"),
                        repeatButtonHandler: repeatButtonPressed(on:)
                    )
                }
            }
        }
        
        DispatchQueue.main.async {
            self.view.refreshCollectionView()
        }
    }
    
    private func floatingLabelDataSource() -> (text: String, alpha: Float) {
        guard let plan = personalPlan else {
            return (text: "", alpha: 0)
        }
        
        if plan.paused {
            return (text: "Your personal plan is on pause", alpha: 0.85)
        } else {
            guard let minutesUntilSleep = PersonalPlanHelper.minutesUntilSleepToday(for: plan)
                else {
                    return (text: "", alpha: 0)
            }
            
            let minutesInDay: Float = 24 * 60
            
            let sleepDuration = plan.sleepDurationSec
            if Float(minutesUntilSleep) >= minutesInDay - Float(sleepDuration / 60) {
                return (text: "It's time to sleep!", alpha: 0.85)
            }
            
            var alpha: Float = (minutesInDay - Float(minutesUntilSleep)) / minutesInDay
            if alpha < 0.3 { alpha = 0.3 }
            if alpha > 0.85 { alpha = 0.85 }
            let timeString = minutesUntilSleep.HHmmString
            
            return (text: "Sleep planned in \(timeString)", alpha: alpha)
        }
    }
    
    private func makeEmptySunCellModel() -> DaysCollectionCellModel {
        return DaysCollectionCellModel(state: .loading,
                                              imageName: (left: "sunrise", right: "sunset"),
                                              repeatButtonHandler: repeatButtonPressed(on:))
    }
    
    private func makeEmptyPlanCellModel() -> DaysCollectionCellModel {
        return DaysCollectionCellModel(state: .showingInfo(info: "No plan for the day"),
                                              imageName: (left: "wakeup", right: "bed"),
                                              repeatButtonHandler: repeatButtonPressed(on:))
    }
    
    
    private func repeatButtonPressed(on cell: DaysCollectionCell) {
        guard let index = view.getIndexOf(cell: cell) else { fatalError() }
        cellModels[index].state = .loading
        view.refreshCollectionView()
        if index % 2 == 0 {
            requestSunTime()
        } else {
            updatePlanView(with: personalPlan)
        }
    }
}
