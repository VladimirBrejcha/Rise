//
//  SunTimeRepository.swift
//  Rise
//
//  Created by Владимир Королев on 10.11.2019.
//  Copyright © 2019 VladimirBrejcha. All rights reserved.
//

import Foundation

final class SunTimeRepository {
    private let local = SunTimeLocalDataSource()
    private let remote = SunTimeRemoteDataSource()
    
    func requestSunTime(for numberOfDays: Int,
                        since day: Date,
                        for location: Location,
                        completion: @escaping (Result<[SunTime], Error>) -> Void
    ) {
        let localResult = local.requestSunTime(for: numberOfDays, since: day)
        
        if case .success(var localSunTimes) = localResult {
            localSunTimes.count == numberOfDays
                ? completion(.success(localSunTimes))
                : remoteRequest(for: calculateMissingDays(from: localSunTimes, and: numberOfDays),
                                since: calculateLatestDay(from: localSunTimes).appending(days: 1)!, // todo force unwrap
                                for: location) { result in
                                    if case .failure (let error) = result { completion(.failure(error)) }
                                    if case .success (let remoteSunTimes) = result {
                                        localSunTimes.append(contentsOf: remoteSunTimes)
                                        completion(.success(localSunTimes))
                                    }
            }
        }
        
        if case .failure(let error) = localResult {
            log(.error, with: error.localizedDescription)
            remoteRequest(for: numberOfDays, since: day, for: location, completion: completion)
        }
    }
    
    @discardableResult func create(sunTime: [SunTime]) -> Bool {
        local.create(sunTimes: sunTime)
    }
    
    @discardableResult func removeSunTime() -> Bool {
        local.deleteAll()
    }
    
    // MARK: - Private -
    private func remoteRequest(for numberOfDays: Int,
                               since day: Date,
                               for location: Location,
                               completion: @escaping (Result<[SunTime], Error>) -> Void
    ) {
        remote.requestSunTime(for: numberOfDays, since: day, for: location) { result in
            if case .success (let remoteSunTimes) = result {
                completion(.success(remoteSunTimes))
                self.create(sunTime: remoteSunTimes)
            }
            if case .failure (let error) = result {
                completion(.failure(error))
            }
        }
    }
    
    private func calculateLatestDay(from sunTimes: [SunTime]) -> Date {
        return sunTimes.sorted { $0.sunrise < $1.sunrise }.last!.sunrise
    }
    
    private func calculateMissingDays(from sunTimes: [SunTime], and numberOfDays: Int) -> Int {
        let missingNumberOfDays = numberOfDays - sunTimes.count
        return missingNumberOfDays
    }
}
