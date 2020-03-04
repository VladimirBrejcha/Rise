//
//  SunTimeRepository.swift
//  Rise
//
//  Created by Владимир Королев on 04.03.2020.
//  Copyright © 2020 VladimirBrejcha. All rights reserved.
//

import Foundation

protocol SunTimeRepository {
    func get(for numberOfDays: Int,
             since day: Date,
             for location: Location,
             completion: @escaping (Result<[SunTime], Error>) -> Void)
    @discardableResult func save(sunTime: [SunTime]) -> Bool
    @discardableResult func deleteAll() -> Bool
}
