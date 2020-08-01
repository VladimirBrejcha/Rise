//
//  TodayStoryPresenter.swift
//  Rise
//
//  Created by Владимир Королев on 14.10.2019.
//  Copyright © 2019-2020 VladimirBrejcha. All rights reserved.
//

import Foundation

fileprivate typealias TodayCollectionCellConfigurator = CollectionCellConfigurator<DaysCollectionCell, DaysCollectionCellModel>

fileprivate let sunImages = (left: "sunrise", right: "sunset")
fileprivate let planImages = (left: "wakeup", right: "bed")

final class TodayStoryPresenter: TodayStoryViewOutput {
    private weak var view: TodayStoryViewInput?
    
    private let getSunTime: GetSunTime
    private let getPlan: GetPlan
    private let observePlan: ObservePlan
    private let getDailyTime: GetDailyTime
    private let confirmPlan: ConfirmPlan
    
    private var latestUsedPlan: RisePlan?
    
    private var collectionDataSource: CollectionDataSource!
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
    
    private var viewIsVisible: Bool = false
    private var needsUpdate: Bool = true
    
    required init(
        view: TodayStoryViewInput,
        getSunTime: GetSunTime,
        getPlan: GetPlan,
        observePlan: ObservePlan,
        getDailyTime: GetDailyTime,
        confirmPlan: ConfirmPlan
    ) {
        self.view = view
        self.getSunTime = getSunTime
        self.getPlan = getPlan
        self.observePlan = observePlan
        self.getDailyTime = getDailyTime
        self.confirmPlan = confirmPlan
    }
    
    // MARK: - TodayStoryViewOutput -
    func viewDidLoad() {
        guard let view = view else { return }
        
        latestUsedPlan = try? getPlan.execute()
        
        collectionDataSource = CollectionDataSource(items: [
            TodayCollectionCellConfigurator(model: makeEmptySunCellModel()),
            TodayCollectionCellConfigurator(model: makeEmptyPlanCellModel()),
            TodayCollectionCellConfigurator(model: makeEmptySunCellModel()),
            TodayCollectionCellConfigurator(model: makeEmptyPlanCellModel()),
            TodayCollectionCellConfigurator(model: makeEmptySunCellModel()),
            TodayCollectionCellConfigurator(model: makeEmptyPlanCellModel())
        ])

        view.setupCollection(with: collectionDataSource)
        requestSunTime()

        observePlan.observe { [weak self] plan in
            guard let self = self else { return }
            self.latestUsedPlan = plan
            self.viewIsVisible
                ? { self.view?.timeToSleepDataSource = self.floatingLabelDataSource
                    self.updateDaysPlanView(with: plan)}()
                : { self.needsUpdate = true }()
        }
    }
    
    let player = AudioPlayer()
    func viewDidAppear() {
        viewIsVisible = true
        if needsUpdate {
            view?.timeToSleepDataSource = floatingLabelDataSource
            self.updateDaysPlanView(with: latestUsedPlan)
            needsUpdate = false
        }
        if let confirmed = try? confirmPlan.checkIfConfirmed() {
            view?.makeTabBar(visible: confirmed)
            if !confirmed { view?.present(controller: Story.confirmation.configure(), with: .overContext) }
        }
//        playSound()
        try! player.play(sound: AlarmSounds.bellAlarm)
    }
    
    func viewWillDisappear() {
        viewIsVisible = false
    }
    
    func sleepPressed() {
        view?.present(controller: Story.prepareToSleep.configure(), with: .modal)
    }
    
    // MARK: - Private -
    private func requestSunTime() {
        getSunTime.execute(for: (numberOfDays: 3, day: NoonedDay.yesterday.date)) { [weak self] result in
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
    
    private func updateDaysPlanView(with plan: RisePlan?) {
        var itemsToReload = [Int]()
        
        for index in cellModels.enumerated() {
            if index.offset.isEven { continue }
            
            if plan != nil {
                let datesArray: [NoonedDay] = [.yesterday, .today, .tomorrow]
                
                if let dailyTime = try? getDailyTime.execute(for: datesArray[(index.offset / 2)].date) {
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
    private func floatingLabelDataSource() -> FloatingLabelModel {
        guard let plan = latestUsedPlan else {
            return FloatingLabelModel(text: "", alpha: 0)
        }
        
        if plan.paused {
            return FloatingLabelModel(text: "Your personal plan is on pause", alpha: 0.85)
        } else {
            guard let todayDailyTime = try? getDailyTime.execute(for: Date().noon)
                else {
                    return FloatingLabelModel(text: "", alpha: 0)
            }
            
            guard let minutesUntilSleep = calendar.dateComponents([.minute], from: Date(), to: todayDailyTime.sleep).minute
                else {
                    return FloatingLabelModel(text: "", alpha: 0)
            }
            
            let minutesInDay: Float = 24 * 60
            
            let sleepDuration = plan.sleepDurationSec
            if Float(minutesUntilSleep) >= minutesInDay - Float(sleepDuration / 60) {
                return FloatingLabelModel(text: "It's time to sleep!", alpha: 0.85)
            }
            
            var alpha: Float = (minutesInDay - Float(minutesUntilSleep)) / minutesInDay
            if alpha < 0.3 { alpha = 0.3 }
            if alpha > 0.85 { alpha = 0.85 }
            let timeString = minutesUntilSleep.HHmmString
            
            return FloatingLabelModel(text: "Sleep planned in \(timeString)", alpha: alpha)
        }
    }
    
    // MARK: - Make empty model
    private func makeEmptySunCellModel() -> DaysCollectionCellModel {
        return DaysCollectionCellModel(state: .loading,
                                       imageName: sunImages,
                                       repeatButtonHandler: repeatButtonPressed(on:))
    }
    
    private func makeEmptyPlanCellModel() -> DaysCollectionCellModel {
        return DaysCollectionCellModel(state: .loading,
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
            : updateDaysPlanView(with: latestUsedPlan)
    }
}

fileprivate extension Int {
    var isEven: Bool { return self % 2 == 0 }

    var isOdd: Bool { return self % 2 != 0 }
}
