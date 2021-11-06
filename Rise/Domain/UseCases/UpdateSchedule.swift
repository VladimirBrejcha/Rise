//
//  UpdateSchedule.swift
//  Rise
//
//  Created by Vladimir Korolev on 07.11.2021.
//  Copyright © 2021 VladimirBrejcha. All rights reserved.
//

import Foundation

protocol UpdateSchedule {
    func callAsFunction(
        current schedule: Schedule,
        wantedSleepDuration: Schedule.Minute?,
        wantedToBed: Date?
    )
}

final class UpdateScheduleImpl: UpdateSchedule {

    private let createSchedule: CreateSchedule
    private let scheduleRepository: ScheduleRepository

    init(_ createSchedule: CreateSchedule,
         _ scheduleRepository: ScheduleRepository
    ) {
        self.createSchedule = createSchedule
        self.scheduleRepository = scheduleRepository
    }

    // todo set correct dates
    func callAsFunction(
        current schedule: Schedule,
        wantedSleepDuration: Schedule.Minute?,
        wantedToBed: Date?
    ) {
        let newSchedule = createSchedule(
            wantedSleepDuration: wantedSleepDuration ?? schedule.sleepDuration,
            currentToBed: schedule.toBed,
            wantedToBed: wantedToBed ?? schedule.targetToBed,
            intensity: schedule.intensity
        )
        scheduleRepository.deleteAll()
        scheduleRepository.save(newSchedule)
    }
}
