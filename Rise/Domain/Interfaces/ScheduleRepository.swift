//
//  ScheduleRepository.swift
//  Rise
//
//  Created by Vladimir Korolev on 06.11.2021.
//  Copyright © 2021 VladimirBrejcha. All rights reserved.
//

import Foundation

protocol ScheduleRepository {
    func get(for date: Date) -> Schedule?
    func getLatest() -> Schedule?
    func save(_ schedule: Schedule)
    func deleteAll()
}
