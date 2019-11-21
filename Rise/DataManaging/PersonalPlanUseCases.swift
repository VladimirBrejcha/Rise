//
//  RequestCurrentPlanUseCase.swift
//  Rise
//
//  Created by Владимир Королев on 13.11.2019.
//  Copyright © 2019 VladimirBrejcha. All rights reserved.
//

import Foundation

protocol RequestPersonalPlanUseCase {
    func request(completion: @escaping (Result<PersonalPlan, Error>) -> Void)
}

protocol UpdatePersonalPlanUseCase {
    func update(plan: PersonalPlan) -> Bool
}

protocol RemovePersonalPlanUseCase {
    func remove(plan: PersonalPlan) -> Bool
}

protocol RequestSunTimeUseCase {
    func request(for numberOfDays: Int, since day: Date,
                 completion: @escaping (Result<[DailySunTime], Error>) -> Void)
}

let sharedUseCaseManager = UseCaseManager()

class UseCaseManager {
    fileprivate let personalPlanRepository = PersonalPlanRepository()
    fileprivate let sunTimeRepository = SunTimeRepository()
    fileprivate let locationRepository = LocationRepository()
}

extension UseCaseManager: RequestPersonalPlanUseCase {
    func request(completion: @escaping (Result<PersonalPlan, Error>) -> Void) {
        personalPlanRepository.requestPersonalPlan(completion: completion)
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

extension UseCaseManager: RequestSunTimeUseCase {
    func request(for numberOfDays: Int, since day: Date,
                 completion: @escaping (Result<[DailySunTime], Error>) -> Void) {
        
        locationRepository.requestLocation { result in
            if case .failure (let error) = result { completion(.failure(error)) }
            if case .success (let location) = result {
                self.sunTimeRepository.requestSunTime(for: numberOfDays, since: day,
                                                      for: location, completion: completion)
            }
        }
    }
}
