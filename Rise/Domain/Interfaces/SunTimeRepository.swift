//
//  SunTimeRepository.swift
//  Rise
//
//  Created by Vladimir Korolev on 04.03.2020.
//  Copyright © 2020 VladimirBrejcha. All rights reserved.
//

import Foundation

protocol SunTimeRepository {
    func get(for numberOfDays: Int,
             since day: Date,
             for location: Location,
             completion: @escaping (Result<[SunTime], Error>) -> Void)
    func save(sunTime: [SunTime]) throws
    func deleteAll() throws
}
