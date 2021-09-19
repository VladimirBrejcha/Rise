//
//  GetSunTime.swift
//  Rise
//
//  Created by Vladimir Korolev on 05.01.2020.
//  Copyright © 2020 VladimirBrejcha. All rights reserved.
//

import Foundation

typealias GetSunTimeCompletion = (Result<[SunTime], Error>) -> Void

protocol GetSunTime {
    func callAsFunction(
        numberOfDays: Int,
        since date: Date,
        completionQueue: DispatchQueue?,
        completion: @escaping GetSunTimeCompletion
    )
}

final class GetSunTimeUseCase: GetSunTime {
    private let locationRepository: LocationRepository
    private let sunTimeRepository: SunTimeRepository
    private let queue = DispatchQueue(label: String(describing: GetSunTimeUseCase.self), qos: .default)
    private var completionQueue: DispatchQueue?
    
    init(_ locationRepository: LocationRepository, _ sunTimeRepository: SunTimeRepository) {
        self.locationRepository = locationRepository
        self.sunTimeRepository = sunTimeRepository
    }
    
    func callAsFunction(
        numberOfDays: Int,
        since date: Date,
        completionQueue: DispatchQueue? = nil,
        completion: @escaping GetSunTimeCompletion
    ) {
        let dates = makeDates(since: date, numberOfDays: numberOfDays)
        queue.async { [weak self] in
            self?.completionQueue = completionQueue
            self?.locationRepository.get { [weak self] result in
                if case .success (let location) = result {
                    self?.getSunTimes(dates: dates, location: location, completion: completion)
                }
                if case .failure (let error) = result {
                    self?.resolveCompletion(completion, with: .failure(error))
                }
            }
        }
    }
    
    private func getSunTimes(
        dates: [Date],
        location: Location,
        completion: @escaping GetSunTimeCompletion
    ) {
        sunTimeRepository.requestSunTimes(
            dates: dates,
            location: location,
            completion: { [weak self] result in
                if case .success (let sunTimes) = result {
                    self?.resolveCompletion(
                        completion,
                        with: .success(
                            sunTimes.sorted { $0.sunrise < $1.sunrise }
                        )
                    )
                }
                if case .failure (let error) = result {
                    self?.resolveCompletion(completion, with: .failure(error))
                }
            }
        )
    }

    private func resolveCompletion(
        _ completion: @escaping GetSunTimeCompletion,
        with result: Result<[SunTime], Error>
    ) {
        if let queue = completionQueue {
            queue.async {
                completion(result)
            }
        } else {
            completion(result)
        }
    }

    private func makeDates(since date: Date, numberOfDays: Int) -> [Date] {
        guard numberOfDays > 0 else { return [] }
        return (0...numberOfDays - 1).map { date.appending(days: $0) }
    }
}
