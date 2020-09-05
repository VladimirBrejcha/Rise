//
//  GetSunTime.swift
//  Rise
//
//  Created by Владимир Королев on 05.01.2020.
//  Copyright © 2020 VladimirBrejcha. All rights reserved.
//

import Foundation

protocol GetSunTime {
    func callAsFunction(numberOfDays: Int, since date: Date, completion: @escaping (Result<[SunTime], Error>) -> Void)
}

final class GetSunTimeUseCase: GetSunTime {
    private let locationRepository: LocationRepository
    private let sunTimeRepository: SunTimeRepository
    
    init(_ locationRepository: LocationRepository, _ sunTimeRepository: SunTimeRepository) {
        self.locationRepository = locationRepository
        self.sunTimeRepository = sunTimeRepository
    }
    
    func callAsFunction(numberOfDays: Int, since date: Date, completion: @escaping (Result<[SunTime], Error>) -> Void) {
        locationRepository.get { [weak self] result in
            if case .success (let location) = result {
                self?.getSunTime(for: numberOfDays, since: date, location: location, completion: completion)
            }
            if case .failure (let error) = result {
                completion(.failure(error))
            }
        }
    }
    
    private func getSunTime(for numberOfDays: Int,
                            since date: Date,
                            location: Location,
                            completion: @escaping (Result<[SunTime], Error>) -> Void
    ) {
        sunTimeRepository.get(for: numberOfDays, since: date, for: location) { result in
            if case .success (let sunTimes) = result {
                completion(.success(sunTimes.sorted { $0.sunrise < $1.sunrise } ))
            }
            if case .failure (let error) = result {
                completion(.failure(error))
            }
        }
    }
}
