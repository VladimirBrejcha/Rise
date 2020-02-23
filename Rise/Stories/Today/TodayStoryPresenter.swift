//
//  TodayStoryPresenter.swift
//  Rise
//
//  Created by Владимир Королев on 14.10.2019.
//  Copyright © 2019 VladimirBrejcha. All rights reserved.
//

import Foundation

fileprivate typealias TodayCollectionCellConfigurator = CollectionCellConfigurator<DaysCollectionCell, DaysCollectionCellModel>

fileprivate let sunImages = (left: "sunrise", right: "sunset")
fileprivate let planImages = (left: "wakeup", right: "bed")

final class TodayStoryPresenter: TodayStoryViewOutput {
    private weak var view: TodayStoryViewInput?
    
    private var personalPlan: PersonalPlan? { getPlan.execute() }
    private let getSunTime: GetSunTime
    private let getPlan: GetPlan
    private let observePlan: ObservePlan
    
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
            dataSource.items = newValue
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
        guard let view = view else { return }
        
        collectionDataSource = CollectionDataSource(items: [
            TodayCollectionCellConfigurator(model: makeEmptySunCellModel()),
            TodayCollectionCellConfigurator(model: makeEmptyPlanCellModel()),
            TodayCollectionCellConfigurator(model: makeEmptySunCellModel()),
            TodayCollectionCellConfigurator(model: makeEmptyPlanCellModel()),
            TodayCollectionCellConfigurator(model: makeEmptySunCellModel()),
            TodayCollectionCellConfigurator(model: makeEmptyPlanCellModel())
        ])

        view.setupCollection(with: collectionDataSource!)
        updateDaysPlanView(with: personalPlan)
        requestSunTime()

        observePlan.execute({ [weak self] plan in
            self?.view?.timeToSleepDataSource = self?.floatingLabelDataSource
            self?.updateDaysPlanView(with: plan)
        })
    }
    
    func viewWillAppear() {
        view?.makeTabBar(visible: true)
    }
    
    func viewDidAppear() {
        guard let plan = personalPlan else { return }
        
        view?.timeToSleepDataSource = floatingLabelDataSource // todo
        
        if !PersonalPlanHelper.isConfirmed(for: .yesterday, plan: plan) {
            view?.makeTabBar(visible: false)
            view?.present(controller: Story.confirmation.configure())
        }
    }
    
    // MARK: - Private -
    private func requestSunTime() {
        getSunTime.execute((numberOfDays: 3, day: Day.yesterday.date)) { [weak self] result in
            if case .success (let sunTime) = result { self?.updateDaysSunView(with: sunTime) }
            if case .failure = result { self?.updateDaysSunView(with: nil) }
        }
    }
    
    // MARK: - Update days view
    private func updateDaysSunView(with sunTimes: [SunTime]?) {
        var itemsToReload = [Int]()
        
        for index in cellModels.enumerated() {
            if index.offset.isOdd { continue }
            
            if let sunTimes = sunTimes {
                let sunTime = sunTimes[index.offset / 2]
                cellModels[index.offset].state = .showingContent(left: sunTime.sunrise.HHmmString,
                                                                 right: sunTime.sunset.HHmmString)
            } else {
                cellModels[index.offset].state = .showingError(error: "Failed to load data")
            }
            
            itemsToReload.append(index.offset)
        }
        
        view?.reloadItems(at: itemsToReload)
    }
    
    private func updateDaysPlanView(with plan: PersonalPlan?) {
        var itemsToReload = [Int]()
        
        for index in cellModels.enumerated() {
            if index.offset.isEven { continue }
            
            if let plan = plan {
                let datesArray: [Day] = [.yesterday, .today, .tomorrow]
                
                if let dailyTime = PersonalPlanHelper.getDailyTime(for: plan,
                                                                   and: datesArray[(index.offset / 2)].date) {
                    cellModels[index.offset].state = .showingContent(left: dailyTime.wake.HHmmString,
                                                                     right: dailyTime.sleep.HHmmString)
                } else {
                    cellModels[index.offset].state = .showingInfo(info: "No plan for the day")
                }
                
            }
            else {
                cellModels[index.offset].state = .showingInfo(info: "You don't have a plan yet")
            }
            
            itemsToReload.append(index.offset)
            
        }
        view?.reloadItems(at: itemsToReload)
    }
    
    // MARK: - Floating label data source
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
    
    // MARK: - Make empty model
    private func makeEmptySunCellModel() -> DaysCollectionCellModel {
        return DaysCollectionCellModel(state: .loading,
                                              imageName: sunImages,
                                              repeatButtonHandler: repeatButtonPressed(on:))
    }
    
    private func makeEmptyPlanCellModel() -> DaysCollectionCellModel {
        return DaysCollectionCellModel(state: .showingInfo(info: "No plan for the day"),
                                              imageName: planImages,
                                              repeatButtonHandler: repeatButtonPressed(on:))
    }
    
    
    // MARK: - Repeat button handler
    private func repeatButtonPressed(on cell: DaysCollectionCell) {
        guard let index = view?.getIndexOf(cell: cell)
            else {
                return
        }
        
        cellModels[index].state = .loading
        
        view?.reloadItem(at: index)
        
        index.isEven
            ? requestSunTime()
            : updateDaysPlanView(with: personalPlan)
    }
}

fileprivate extension Int {
    var isEven: Bool { return self % 2 == 0 }

    var isOdd: Bool { return self % 2 != 0 }
}
