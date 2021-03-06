//
//  SunTimeRepository.swift
//  Rise
//
//  Created by Владимир Королев on 10.11.2019.
//  Copyright © 2019-2020 VladimirBrejcha. All rights reserved.
//

import Foundation

final class DefaultSunTimeRepository: SunTimeRepository {
    private let localDataSource: SunTimeLocalDataSource
    private let remoteDataSource: SunTimeRemoteDataSource
    
    init(_ localDataSource: SunTimeLocalDataSource, _ remoteDataSource: SunTimeRemoteDataSource) {
        self.localDataSource = localDataSource
        self.remoteDataSource = remoteDataSource
    }
    
    func get(for numberOfDays: Int,
             since day: Date,
             for location: Location,
             completion: @escaping (Result<[SunTime], Error>) -> Void
    ) {
        do {
            var localResult = try localDataSource.get(for: numberOfDays, since: day)
            if localResult.isEmpty {
                remoteRequest(for: numberOfDays, since: day, for: location, completion: completion)
                return
            }

            if (localResult.count == numberOfDays) {
                log(.info, "found stored sunTimes: \(localResult)")
                completion(.success(localResult))
                return
            }
            
            remoteRequest(for: calculateMissingDays(from: localResult, and: numberOfDays),
                          since: calculateLatestDay(from: localResult).appending(days: 1),
                          for: location) { result in
                if case .success (let remotResult) = result {
                    localResult.append(contentsOf: remotResult)
                    completion(.success(localResult))
                }
                if case .failure (let error) = result {
                    completion(.failure(error))
                }
            }
        } catch {
            remoteRequest(for: numberOfDays, since: day, for: location, completion: completion)
        }
    }
    
    func save(sunTime: [SunTime]) throws {
        try localDataSource.save(sunTimes: sunTime)
    }
    
    func deleteAll() throws {
        try localDataSource.deleteAll()
    }
    
    // MARK: - Private -
    private func remoteRequest(for numberOfDays: Int,
                               since day: Date,
                               for location: Location,
                               completion: @escaping (Result<[SunTime], Error>) -> Void
    ) {
        remoteDataSource.get(for: numberOfDays, since: day, for: location) { result in
            if case .success (let remoteSunTimes) = result {
                completion(.success(remoteSunTimes))
                log(.info, "got sunTimes: \(remoteSunTimes)")
                try? self.save(sunTime: remoteSunTimes)
            }
            if case .failure (let error) = result {
                log(.warning, "got error: \(error.localizedDescription)")
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
