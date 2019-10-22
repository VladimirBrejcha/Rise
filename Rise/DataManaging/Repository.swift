//
//  Repository.swift
//  Rise
//
//  Created by Владимир Королев on 12.10.2019.
//  Copyright © 2019 VladimirBrejcha. All rights reserved.
//

import Foundation

protocol SunTimeDataSource: AnyObject {
    func requestSunForecast(for numberOfDays: Int, at startingDate: Date, with location: LocationModel,
                        completion: @escaping (Swift.Result<[SunTimeModel], Error>) -> Void)
}

protocol RiseRepository: AnyObject {
    func requestLocation(with completion: @escaping (Result<LocationModel, Error>) -> Void)
    func requestSunForecast(for numberOfDays: Int, at startingDate: Date, with location: LocationModel,
                         completion: @escaping (Swift.Result<[SunTimeModel], Error>) -> Void)
    
}

class Repository: RiseRepository {
    private let remoteDataSource: SunTimeDataSource = SunAPIService()
    private let localDataSource = sharedCoreDataManager
    private let locationManager = sharedLocationManager
    
    func requestSunForecast(for numberOfDays: Int, at startingDate: Date, with location: LocationModel,
                            completion: @escaping (Result<[SunTimeModel], Error>) -> Void) {
        
        localDataSource.requestSunForecast(for: numberOfDays, at: startingDate, with: location)
        { result in
            if case .failure (let error) = result
            {
                print(error)
                self.remoteDataSource.requestSunForecast(for: numberOfDays, at: startingDate, with: location)
                { result in
                    if case .failure (let error) = result { completion(.failure(error)) }
                    else if case .success (let sunTimeModelArray) = result {
                        sunTimeModelArray.forEach { self.localDataSource.createSunTimeObject(with: $0) }
                        completion(.success(sunTimeModelArray)) }
                }
            }
                
            else if case .success (let localSunTimeModelArray) = result
            {
                if localSunTimeModelArray.count == numberOfDays { completion(.success(localSunTimeModelArray)) }
                else
                {
                    var sortedLocalSunTimeModelArray = localSunTimeModelArray.sorted { $0.day > $1.day }
                    let latestStoredSunTimeModel = sortedLocalSunTimeModelArray.last!
                    let missingNumberOfModels = numberOfDays - localSunTimeModelArray.count
                    self.remoteDataSource.requestSunForecast(for: missingNumberOfModels,
                                                             at: latestStoredSunTimeModel.day, with: location)
                    { result in
                        if case .failure (let error) = result { completion(.failure(error)) }
                        else if case .success (let sunTimeModelArray) = result {
                            sunTimeModelArray.forEach { self.localDataSource.createSunTimeObject(with: $0) }
                            sortedLocalSunTimeModelArray.append(contentsOf: sunTimeModelArray)
                            completion(.success(sortedLocalSunTimeModelArray)) }
                    }
                }
            }
        }
    }
    
    func requestLocation(with completion: @escaping (Result<LocationModel, Error>) -> Void) {
        locationManager.requestNewLocation { result in
            if case .failure (let error) = result { completion(.failure(error)) }
            else if case .success (let location) = result { completion(.success(location)) }
        }
    }
    
}

