//
//  MainScreenPresenter.swift
//  Rise
//
//  Created by Владимир Королев on 14.10.2019.
//  Copyright © 2019 VladimirBrejcha. All rights reserved.
//

import Foundation

class MainScreenPresenter: MainScreenViewOutput, TodayCollectionViewCellDelegate {
    weak var view: MainScreenViewInput?
    
    private let requestSunTimeUseCase: RequestSunTimeUseCase = sharedUseCaseManager
    private let requestPersonalPlanUseCase: RequestPersonalPlanUseCase = sharedUseCaseManager
    
    private var cellModels: [TodayCellModel] {
        get { return collectionViewDataSource.models }
        set { collectionViewDataSource.models = newValue }
    }
    private var collectionViewDataSource: CollectionViewDataSource<TodayCellModel>!
    
    init(view: MainScreenViewInput) { self.view = view }
    
    // MARK: - MainScreenViewOutput
    func viewDidLoad() {
        collectionViewDataSource = .make(for: [TodayCellModel(day: Date().appending(days: -1)),
                                               TodayCellModel(day: Date()),
                                               TodayCellModel(day: Date().appending(days: 1))],
                                         cellDelegate: self)
        view?.setupCollectionView(with: collectionViewDataSource)
    }
    
    func viewDidAppear() {
        requestSunTime()
        requestPlan()
    }
    
    // MARK: - TodayCollectionViewCellDelegate
    func repeatButtonPressed(on cell: TodayCollectionViewCell) {
        if let index = cellModels.firstIndex(where: { cellModel in
            return Calendar.current.isDate(cellModel.day, inSameDayAs: cell.cellModel.day)
        }) {
            cellModels[index].sunErrorMessage = nil
            view?.refreshCollectionView()
            requestSunTime()
        }
    }
    
    // MARK: - Private Methods
    private func requestSunTime() {
        requestSunTimeUseCase.request(for: 3, since: Date().appending(days: -1)) { [weak self] result in
            guard let self = self else { return }
            if case .success (let sunTime) = result { self.updateView(with: sunTime) }
            if case .failure (let error) = result { self.updateSunView(with: error) }
        }
    }
    
    private func requestPlan() {
        let result = requestPersonalPlanUseCase.request()
        
        if case .success (let plan) = result { updateView(with: plan) }
        if case .failure (let error) = result { updatePlanView(with: error) }
    }
    
    private func updateView(with sunModelArray: [DailySunTime]) {
        guard let view = view else { return }
        
        sunModelArray.forEach { sunModel in
            if let index = cellModels.firstIndex(where: { cellModel in
                return Calendar.current.isDate(cellModel.day, inSameDayAs: sunModel.day)
            }) {
                cellModels[index].update(sunTime: sunModel)
            }
        }
        view.refreshCollectionView()
    }
    
    private func updateView(with plan: PersonalPlan) {
        guard let view = view else { return }
        
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
        view.refreshCollectionView()
    }
    
    private func updatePlanView(with planError: Error) {
        guard let view = view else { return }
        
        log(planError.localizedDescription)
        for index in self.cellModels.enumerated() {
            self.cellModels[index.offset].planErrorMessage = "You have no Rise plan yet"
        }
        
        view.refreshCollectionView()
    }
    
    private func updateSunView(with sunTimeError: Error) {
        guard let view = view else { return }
        
        log(sunTimeError.localizedDescription)
        for index in self.cellModels.enumerated() {
            self.cellModels[index.offset].sunErrorMessage = "Failed to load data"
        }
        
        view.refreshCollectionView()
    }
}
