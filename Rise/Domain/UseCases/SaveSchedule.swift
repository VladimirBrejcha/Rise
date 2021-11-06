//
//  SaveSchedule.swift
//  Rise
//
//  Created by Vladimir Korolev on 06.11.2021.
//  Copyright © 2021 VladimirBrejcha. All rights reserved.
//

import Foundation

protocol SaveSchedule {
    func callAsFunction(_ schedule: Schedule)
}

final class SaveScheduleImpl: SaveSchedule {
    private let scheduleRepository: ScheduleRepository

    init(_ scheduleRepository: ScheduleRepository) {
        self.scheduleRepository = scheduleRepository
    }

    func callAsFunction(_ schedule: Schedule) {
        scheduleRepository.save(schedule)
    }
}
