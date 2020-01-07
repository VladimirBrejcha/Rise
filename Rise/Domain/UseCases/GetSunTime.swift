//
//  GetSunTime.swift
//  Rise
//
//  Created by Владимир Королев on 05.01.2020.
//  Copyright © 2020 VladimirBrejcha. All rights reserved.
//

import Foundation

final class GetSunTime: UseCase {
    typealias InputValue = (numberOfDays: Int, day: Date)
    typealias CompletionHandler = (Result<[DailySunTime], Error>) -> Void
    typealias OutputValue = Void
    
    private let locationRepository: LocationRepository
    private let sunTimeRepository: SunTimeRepository
    
    required init(locationRepository: LocationRepository, sunTimeRepository: SunTimeRepository) {
        self.locationRepository = locationRepository
        self.sunTimeRepository = sunTimeRepository
    }
    
    func execute(_ requestValue: (numberOfDays: Int, day: Date), completion: @escaping (Result<[DailySunTime], Error>) -> Void) {
        locationRepository
            .requestLocation {
                [weak self] result in
                guard let self = self else { return }
                
                if case .failure (let error) = result { completion(.failure(error)) }
                if case .success (let location) = result {
                    self.sunTimeRepository
                        .requestSunTime(for: requestValue.numberOfDays,
                                        since: requestValue.day,
                                        for: location) {
                                            result in
                                            
                                            if case .failure (let error) = result { completion(.failure(error)) }
                                            if case .success (let sunTimes) = result {
                                                completion(.success(sunTimes.sorted  {$0.day < $1.day }))
                                            }
                    }
                }
        }
    }
    
}
