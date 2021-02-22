//
//  GetSunTime.swift
//  Rise
//
//  Created by Владимир Королев on 05.01.2020.
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
    private let queue = DispatchQueue(label: "GetSunTime", qos: .default)
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
        queue.async { [weak self] in
            self?.completionQueue = completionQueue
            self?.locationRepository.get { [weak self] result in
                if case .success (let location) = result {
                    self?.getSunTime(for: numberOfDays, since: date, location: location, completion: completion)
                }
                if case .failure (let error) = result {
                    self?.resolveCompletion(completion, with: .failure(error))
                }
            }
        }
    }
    
    private func getSunTime(
        for numberOfDays: Int,
        since date: Date,
        location: Location,
        completion: @escaping GetSunTimeCompletion
    ) {
        queue.async { [weak self] in
            self?.sunTimeRepository.get(for: numberOfDays, since: date, for: location) { result in
                if case .success (let sunTimes) = result {
                    self?.resolveCompletion(completion, with: .success(sunTimes.sorted { $0.sunrise < $1.sunrise } ))
                }
                if case .failure (let error) = result {
                    self?.resolveCompletion(completion, with: .failure(error))
                }
            }
        }
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
}
