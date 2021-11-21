//
//  UpdateSchedule.swift
//  Rise
//
//  Created by Vladimir Korolev on 07.11.2021.
//  Copyright © 2021 VladimirBrejcha. All rights reserved.
//

import Foundation

/*
 * Creates new schedule with given parameters or with fallback to current schedule parameters
 * Deletes old schedule from the storage
 * Saves new schedule to the storage
 */
protocol UpdateSchedule {
    func callAsFunction(
        current schedule: Schedule,
        newSleepDuration: Schedule.Minute?,
        newToBed: Date?,
        newIntensity: Schedule.Intensity?
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

    func callAsFunction(
        current schedule: Schedule,
        newSleepDuration: Schedule.Minute?,
        newToBed: Date?,
        newIntensity: Schedule.Intensity?
    ) {
        let newSchedule = createSchedule(
            wantedSleepDuration: newSleepDuration ?? schedule.sleepDuration,
            currentToBed: schedule.toBed,
            wantedToBed: newToBed?.normalised(with: schedule.targetToBed) ?? schedule.targetToBed,
            intensity: newIntensity ?? schedule.intensity
        )
        if newSchedule == schedule {
            log(.warning, "No changes, early return")
            return
        }
        scheduleRepository.deleteAll()
        scheduleRepository.save(newSchedule)
    }
}

fileprivate extension Date {
    func normalised(with date: Date) -> Date {
        let components = calendar.dateComponents([.hour, .minute], from: self)
        guard let hour = components.hour,
              let minute = components.minute,
              let date = calendar.date(
                bySettingHour: hour,
                minute: minute,
                second: 0,
                of: date
              )
        else {
            assertionFailure("Could'nt build a date")
            return date
        }
        return date
    }
}
