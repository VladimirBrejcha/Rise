//
//  SunTimeRepository.swift
//  Rise
//
//  Created by Владимир Королев on 10.11.2019.
//  Copyright © 2019 VladimirBrejcha. All rights reserved.
//

import Foundation

class SunTimeRepository {
    private let local = SunTimeLocalDataSource()
    private let remote = SunTimeRemoteDataSource()
    
    func requestSunTime(for numberOfDays: Int, since day: Date, for location: Location,
                     completion: @escaping (Result<[DailySunTime], Error>) -> Void) {
        switch local.requestSunTime(for: numberOfDays, since: day) {
        case .success(var localSunTimes):
            localSunTimes.count == numberOfDays
                ? completion(.success(localSunTimes))
                : remoteRequest(for: calculateMissingDays(from: localSunTimes, and: numberOfDays),
                                since: calculateLatestDay(from: localSunTimes).appending(days: 1),
                                for: location) { result in
                                    if case .failure (let error) = result { completion(.failure(error)) }
                                    if case .success (let remoteLocation) = result {
                                        localSunTimes.append(contentsOf: remoteLocation)
                                        completion(.success(localSunTimes))
                                    }
                                    
            }
            
        case .failure(let error):
            log(error.localizedDescription)
            remoteRequest(for: numberOfDays, since: day, for: location, completion: completion)
        }
    }
    
    @discardableResult func create(sunTime: [DailySunTime]) -> Bool {
        local.create(sunTimes: sunTime)
    }
    
    @discardableResult func removeSunTime() -> Bool {
        local.deleteAll()
    }
    
    // MARK: - Private -
    private func remoteRequest(for numberOfDays: Int, since day: Date, for location: Location,
                               completion: @escaping (Result<[DailySunTime], Error>) -> Void) {
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
    
    private func calculateLatestDay(from sunTimes: [DailySunTime]) -> Date {
        return sunTimes.sorted { $0.day > $1.day }.last!.day
    }
    
    private func calculateMissingDays(from sunTimes: [DailySunTime], and numberOfDays: Int) -> Int {
        let missingNumberOfDays = numberOfDays - sunTimes.count
        return missingNumberOfDays
    }
}
