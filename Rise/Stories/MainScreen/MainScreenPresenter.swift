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
    
    private let locationManager = sharedLocationManager
    private let repository: RiseRepository = sharedRepository
    
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
        requestLocation()
    }
    
    // MARK: - Private Methods
    private func requestLocation() {
        guard let view = view else { return }
        repository.requestLocation { [weak self] result in
            guard let self = self else { return }
            if case .failure (let error) = result { view.showError(with: error.localizedDescription) }
            else if case .success (let locationModel) = result { self.newLocationDataArrived(locationModel: locationModel) }
        }
    }
    
    
    private func newLocationDataArrived(locationModel: LocationModel) {
        repository.requestSunForecast(for: 3, at: Date(), with: locationModel) { [weak self] result in
            guard let self = self else { return }
            if case .failure (let error) = result {
                self.view?.showSunTimeLoadingError()
                self.view?.showError(with: error.localizedDescription) }
            else if case .success (let sunModelArray) = result {
                self.updateView(with: sunModelArray.sorted { $0.day < $1.day } )
            }
        }
    }
    
    private func updateView(with sunModelArray: [SunTimeModel]) {
        guard let view = view else { return }
        var models: [TodayCellModel] = []
        sunModelArray.forEach { sunModel in models.append(buildCellModel(from: sunModel)) }
        cellModels = models
        view.refreshCollectionView()
    }
    
    private func buildCellModel(from sunModel: SunTimeModel) -> TodayCellModel {
        return TodayCellModel(isDataLoaded: true, sunriseTime: DatesConverter.formatDateToHHmm(date: sunModel.sunrise),
                              sunsetTime: DatesConverter.formatDateToHHmm(date: sunModel.sunset))
    }
}
