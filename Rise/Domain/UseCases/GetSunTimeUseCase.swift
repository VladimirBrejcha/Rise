//
//  GetSunTime.swift
//  Rise
//
//  Created by Владимир Королев on 05.01.2020.
//  Copyright © 2020 VladimirBrejcha. All rights reserved.
//

import Foundation

protocol GetSunTime {
    func callAsFunction(for requestValue: (numberOfDays: Int, day: Date),
                        completion: @escaping (Result<[SunTime], Error>) -> Void)
}

final class GetSunTimeUseCase: GetSunTime {
    private let locationRepository: LocationRepository
    private let sunTimeRepository: SunTimeRepository
    
    init(_ locationRepository: LocationRepository, _ sunTimeRepository: SunTimeRepository) {
        self.locationRepository = locationRepository
        self.sunTimeRepository = sunTimeRepository
    }
    
    func callAsFunction(
        for requestValue: (numberOfDays: Int, day: Date),
        completion: @escaping (Result<[SunTime], Error>) -> Void
    ) {
        locationRepository.get { [weak self] result in
            guard let self = self else { return }
            
            if case .success (let location) = result {
                self.sunTimeRepository.get(
                    for: requestValue.numberOfDays,
                    since: requestValue.day,
                    for: location
                ) { result in
                    if case .failure (let error) = result { completion(.failure(error)) }
                    if case .success (let sunTimes) = result {
                        completion(.success(sunTimes.sorted  {$0.sunrise < $1.sunrise }))
                    }
                }
            }
            
            if case .failure (let error) = result { completion(.failure(error)) }
        }
    }
}
