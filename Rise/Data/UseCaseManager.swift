//
//  RequestCurrentPlanUseCase.swift
//  Rise
//
//  Created by Владимир Королев on 13.11.2019.
//  Copyright © 2019 VladimirBrejcha. All rights reserved.
//

import Foundation

struct DataLayer {
    static let personalPlanRepository: PersonalPlanRepository = {
        return PersonalPlanRepository()
    }()
    
    static let sunTimeRepository: SunTimeRepository = {
        return SunTimeRepository()
    }()
    
    static let locationRepository: LocationRepository = {
        return LocationRepository()
    }()
}



protocol RequestPersonalPlanUseCase {
    func request() -> Result<PersonalPlan, Error>
}

protocol UpdatePersonalPlanUseCase {
    func update(plan: PersonalPlan) -> Bool
}

protocol SavePersonalPlanUseCase {
    func save(plan: PersonalPlan) -> Bool
}

protocol RemovePersonalPlanUseCase {
    func remove(plan: PersonalPlan) -> Bool
}

protocol RequestSunTimeUseCase {
    func request(for numberOfDays: Int, since day: Date,
                 completion: @escaping (Result<[DailySunTime], Error>) -> Void)
}

protocol ReceivePersonalPlanUpdatesUseCase {
    func receive(_ updateCompletion: @escaping (PersonalPlan?) -> Void)
}

let sharedUseCaseManager = UseCaseManager()

final class UseCaseManager {
    fileprivate let personalPlanRepository = PersonalPlanRepository()
    fileprivate let sunTimeRepository = SunTimeRepository()
    fileprivate let locationRepository = LocationRepository()
}

extension UseCaseManager: SavePersonalPlanUseCase {
    func save(plan: PersonalPlan) -> Bool {
        return personalPlanRepository.create(personalPlan: plan)
    }
}

extension UseCaseManager: RequestPersonalPlanUseCase {
    func request() -> Result<PersonalPlan, Error> {
        return personalPlanRepository.requestPersonalPlan()
    }
}

extension UseCaseManager: UpdatePersonalPlanUseCase {
    func update(plan: PersonalPlan) -> Bool {
        personalPlanRepository.update(personalPlan: plan)
    }
}

extension UseCaseManager: RemovePersonalPlanUseCase {
    func remove(plan: PersonalPlan) -> Bool {
        personalPlanRepository.removePersonalPlan()
    }
}

extension UseCaseManager: ReceivePersonalPlanUpdatesUseCase {
    func receive(_ updateCompletion: @escaping (PersonalPlan?) -> Void) {
        personalPlanRepository.personalPlanUpdateOutput = updateCompletion
    }
}

extension UseCaseManager: RequestSunTimeUseCase {
    func request(for numberOfDays: Int, since day: Date,
                 completion: @escaping (Result<[DailySunTime], Error>) -> Void) {
        
        locationRepository.requestLocation { result in
            if case .failure (let error) = result { completion(.failure(error)) }
            if case .success (let location) = result {
                self.sunTimeRepository.requestSunTime(for: numberOfDays, since: day,
                                                      for: location) { result in
                                                        if case .failure (let error) = result { completion(.failure(error)) }
                                                        if case .success (let sunTimes) = result {
                                                            completion(.success(sunTimes.sorted { $0.day < $1.day }))
                                                        }
                                                        
                }
            }
        }
    }
}
