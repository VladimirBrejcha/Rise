//
//  RisePlanRepository.swift
//  Rise
//
//  Created by Владимир Королев on 04.03.2020.
//  Copyright © 2020 VladimirBrejcha. All rights reserved.
//

import Foundation

protocol RisePlanRepository {
    func get() throws -> RisePlan
    func update(plan: RisePlan) throws
    func save(plan: RisePlan) throws
    func removeAll() throws
    func add(observer: @escaping PlanObserver, with uuid: UUID)
    func removeObserver(with uuid: UUID)
}
