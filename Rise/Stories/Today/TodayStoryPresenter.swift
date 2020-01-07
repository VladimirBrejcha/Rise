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
        collectionViewDataSource = .make(for: [DaysCollectionViewCellModel(day: Date().appending(days: -1)),
                                               DaysCollectionViewCellModel(day: Date()),
                                               DaysCollectionViewCellModel(day: Date().appending(days: 1))],
                                         cellDelegate: self)
        view.setupCollectionView(with: collectionViewDataSource)
        
        updatePlanView(with: getPlan.execute())
        requestSunTime()
        
        observePlan.execute({ [weak self] plan in
            self?.updatePlanView(with: plan)
        })
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
        getSunTime.execute((numberOfDays: 3, day: Date().appending(days: -1))) { [weak self] result in
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
                if let index = cellModels.firstIndex(where: { model in
                    return Calendar.current.isDate(model.day, inSameDayAs: model.day)
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
            plan.dailyTimes.forEach { dailyTime in
                if let index = cellModels.firstIndex(where: { cellModel in
                    return Calendar.current.isDate(cellModel.day, inSameDayAs: dailyTime.day)
                }) {
                    cellModels[index].update(planTime: dailyTime)
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
