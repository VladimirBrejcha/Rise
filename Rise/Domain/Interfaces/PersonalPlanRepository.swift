//
//  PersonalPlanRepository.swift
//  Rise
//
//  Created by Владимир Королев on 04.03.2020.
//  Copyright © 2020 VladimirBrejcha. All rights reserved.
//

import Foundation

protocol PersonalPlanRepository {
    func get() -> Result<PersonalPlan, Error>
    @discardableResult func update(personalPlan: PersonalPlan) -> Bool
    @discardableResult func save(personalPlan: PersonalPlan) -> Bool
    @discardableResult func removeAll() -> Bool
    func add(observer: @escaping PlanObserver, with uuid: UUID)
    func removeObserver(with uuid: UUID)
}
