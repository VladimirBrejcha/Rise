//
//  MainScreenPresenter.swift
//  Rise
//
//  Created by Владимир Королев on 14.10.2019.
//  Copyright © 2019 VladimirBrejcha. All rights reserved.
//

import Foundation

final class TodayStoryPresenter: TodayStoryViewOutput, DaysCollectionViewCellDelegate {
    private unowned var view: TodayStoryViewInput
    
    private let getSunTime: GetSunTime
    private let getPlan: GetPlan
    private let observePlan: ObservePlan
    
    private var personalPlan: PersonalPlan? {
        return getPlan.execute()
    }
    
    private var cellModels: [DaysCollectionViewCellModel] {
        get { return collectionViewDataSource.models }
        set { collectionViewDataSource.models = newValue }
    }
    
    private var collectionViewDataSource: CollectionViewDataSource<DaysCollectionViewCellModel>!
    
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
        collectionViewDataSource = .make(for: [DaysCollectionViewCellModel(day: .yesterday),
                                               DaysCollectionViewCellModel(day: .today),
                                               DaysCollectionViewCellModel(day: .tomorrow)],
                                         cellDelegate: self)
        view.setupCollectionView(with: collectionViewDataSource)
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
    
    // MARK: - DaysCollectionViewCellDelegate -
    func repeatButtonPressed(on cell: DaysCollectionViewCell) {
        if let index = cellModels.firstIndex(where: { cellModel in
            return calendar.isDate(cellModel.day.date, inSameDayAs: cell.cellModel.day.date) // TODO try to compare days
        }) {
            cellModels[index].sunErrorMessage = nil
            view.refreshCollectionView()
            requestSunTime()
        }
    }
    
    // MARK: - Private Methods -
    private func requestSunTime() {
        guard let yesterday = Date().appending(days: -1)
            else {
                return
        }
        
        getSunTime.execute((numberOfDays: 3, day: yesterday)) { [weak self] result in
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
            models.forEach { model in
                if let index = cellModels.firstIndex(where: { cellModel in
                    return Calendar.current.isDate(cellModel.day.date, inSameDayAs: model.day)
                }) {
                    cellModels[index].update(sunTime: model)
                }
            }
        } else {
            for index in cellModels.enumerated() {
                cellModels[index.offset].sunErrorMessage = "Failed to load data"
            }
        }
        DispatchQueue.main.async {
            self.view.refreshCollectionView()
        }
    }
    
    private func updatePlanView(with plan: PersonalPlan?) {
        if let plan = plan {
            for index in cellModels.enumerated() {
                cellModels[index.offset].planErrorMessage = "No Rise plan for the day"
            }
            
            let datesArray: [Day] = [.yesterday, .today, .tomorrow]
            
            for index in datesArray.enumerated() {
                if let dailyTime = PersonalPlanHelper.getDailyTime(for: plan, and: datesArray[index.offset].date) {
                    cellModels[index.offset].update(planTime: dailyTime)
                }
            }
        } else {
            for index in self.cellModels.enumerated() {
                self.cellModels[index.offset].planErrorMessage = "You have no Rise plan yet"
            }
        }
        view.refreshCollectionView()
    }
    
    private func floatingLabelDataSource() -> (text: String, alpha: Float) {
        guard let plan = self.getPlan.execute() else {
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
}
