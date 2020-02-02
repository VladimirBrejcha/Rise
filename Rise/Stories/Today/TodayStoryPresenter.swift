//
//  MainScreenPresenter.swift
//  Rise
//
//  Created by Владимир Королев on 14.10.2019.
//  Copyright © 2019 VladimirBrejcha. All rights reserved.
//

import Foundation

final class TodayStoryPresenter: TodayStoryViewOutput, DaysCollectionViewCellDelegate {
    unowned var view: TodayStoryViewInput
    
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
        guard let yesterday = Date().appending(days: -1),
            let tomorrow = Date().appending(days: 1)
            else {
                return
        }
        
        collectionViewDataSource = .make(for: [DaysCollectionViewCellModel(day: yesterday),
                                               DaysCollectionViewCellModel(day: Date()),
                                               DaysCollectionViewCellModel(day: tomorrow)],
                                         cellDelegate: self)
        view.setupCollectionView(with: collectionViewDataSource)
        
        updatePlanView(with: getPlan.execute())
        requestSunTime()
        
        observePlan.execute({ [weak self] plan in
            self?.updatePlanView(with: plan)
        })
    }
    
    func viewWillAppear() {
        view.makeTabBar(visible: true)
    }
    
    func viewDidAppear() {
        guard let plan = personalPlan else { return }
        
        if !PersonalPlanHelper.isConfirmedForToday(plan: plan) {
            view.makeTabBar(visible: false)
            view.present(controller: Story.confirmation.configure())
        }
    }
    
    // MARK: - DaysCollectionViewCellDelegate -
    func repeatButtonPressed(on cell: DaysCollectionViewCell) {
        if let index = cellModels.firstIndex(where: { cellModel in
            return Calendar.current.isDate(cellModel.day, inSameDayAs: cell.cellModel.day)
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
                log(error.localizedDescription)
                self.updateSunTimeView(with: nil)
            }
        }
    }
    
    private func updateSunTimeView(with sunModelArray: [DailySunTime]?) {
        if let models = sunModelArray {
            models.forEach { model in
                if let index = cellModels.firstIndex(where: { cellModel in
                    return Calendar.current.isDate(cellModel.day, inSameDayAs: model.day)
                }) {
                    cellModels[index].update(sunTime: model)
                }
            }
        } else {
            for index in cellModels.enumerated() {
                cellModels[index.offset].sunErrorMessage = "Failed to load data"
            }
        }
        view.refreshCollectionView()
    }
    
    private func updatePlanView(with plan: PersonalPlan?) {
        if let plan = plan {
            for index in cellModels.enumerated() {
                cellModels[index.offset].planErrorMessage = "No Rise plan for the day"
            }
            
            let calendar = Calendar.autoupdatingCurrent
            let today = Date()
            let yesterday = calendar.date(byAdding: .day, value: -1, to: today)
            let tomorrow = calendar.date(byAdding: .day, value: 1, to: today)
            
            let datesArray = [yesterday, today, tomorrow]
            
            for index in datesArray.enumerated() {
                if let dailyTime = PersonalPlanHelper.getDailyTime(for: plan, and: datesArray[index.offset]!) {
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
}
