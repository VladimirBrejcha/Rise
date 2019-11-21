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
    
    private var cellModels: [TodayCellModel] {
        get { return collectionViewDataSource.models }
        set { collectionViewDataSource.models = newValue }
    }
    private let collectionViewDataSource: CollectionViewDataSource<TodayCellModel>
        = .make(for: [TodayCellModel(isDataLoaded: false, sunriseTime: "", sunsetTime: ""),
                      TodayCellModel(isDataLoaded: false, sunriseTime: "", sunsetTime: ""),
                      TodayCellModel(isDataLoaded: false, sunriseTime: "", sunsetTime: "")])
    
    init(view: MainScreenViewInput) {
        self.view = view
        view.setupCollectionView(with: collectionViewDataSource)
    }
    
    // MARK: - MainScreenViewOutput
    func viewDidLoad() {
        requestSunTimeUseCase.request(for: 3, since: Date() - 1) { [weak self] result in
            guard let self = self else { return }
            if case .failure (let error) = result {
                
            }
            if case .success (let sunTime) = result {
                self.updateView(with: sunTime)
            }
        }
    }
    
    // MARK: - Private Methods
    
    private func updateView(with sunModelArray: [DailySunTime]) {
        guard let view = view else { return }
        var models: [TodayCellModel] = []
        sunModelArray.forEach { sunModel in models.append(buildCellModel(from: sunModel)) }
        cellModels = models
        view.refreshCollectionView()
    }
    
    private func buildCellModel(from sunModel: DailySunTime) -> TodayCellModel {
        return TodayCellModel(isDataLoaded: true, sunriseTime: DatesConverter.formatDateToHHmm(date: sunModel.sunrise),
                              sunsetTime: DatesConverter.formatDateToHHmm(date: sunModel.sunset))
    }
}
