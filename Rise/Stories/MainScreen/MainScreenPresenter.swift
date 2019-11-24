//
//  MainScreenPresenter.swift
//  Rise
//
//  Created by Владимир Королев on 14.10.2019.
//  Copyright © 2019 VladimirBrejcha. All rights reserved.
//

import Foundation

class MainScreenPresenter: MainScreenViewOutput {
    weak var view: MainScreenViewInput?
    
    private let requestSunTimeUseCase: RequestSunTimeUseCase = sharedUseCaseManager
    private let requestPersonalPlanUseCase: RequestPersonalPlanUseCase = sharedUseCaseManager
    
    private var cellModels: [TodayCellModel] {
        get { return collectionViewDataSource.models }
        set { collectionViewDataSource.models = newValue }
    }
    private let collectionViewDataSource: CollectionViewDataSource<TodayCellModel>
        = .make(for: [TodayCellModel(day: Date().appending(days: -1)),
                      TodayCellModel(day: Date()),
                      TodayCellModel(day: Date().appending(days: 1))])
    
    init(view: MainScreenViewInput) {
        self.view = view
        view.setupCollectionView(with: collectionViewDataSource)
    }
    
    // MARK: - MainScreenViewOutput
    func viewDidLoad() {
        requestSunTimeUseCase.request(for: 3, since: Date().appending(days: -1)) { [weak self] result in
            guard let self = self else { return }
            if case .success (let sunTime) = result {
                self.updateView(with: sunTime)
            }
            if case .failure (let error) = result {
                log(error.localizedDescription)
                UIHelper.showError(errorMessage: error.localizedDescription)
            }
        }
    }
    
    // MARK: - Private Methods
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
}
