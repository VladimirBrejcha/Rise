//
//  PersonalPlanRepository.swift
//  Rise
//
//  Created by Владимир Королев on 04.03.2020.
//  Copyright © 2020 VladimirBrejcha. All rights reserved.
//

import Foundation

protocol PersonalPlanRepository {
    func get() throws -> PersonalPlan
    func update(plan: PersonalPlan) throws
    func save(plan: PersonalPlan) throws
    func removeAll() throws
    func add(observer: @escaping PlanObserver, with uuid: UUID)
    func removeObserver(with uuid: UUID)
}
