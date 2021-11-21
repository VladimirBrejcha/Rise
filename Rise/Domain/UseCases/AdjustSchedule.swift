//
//  AdjustSchedule.swift
//  Rise
//
//  Created by Vladimir Korolev on 21.11.2021.
//  Copyright © 2021 VladimirBrejcha. All rights reserved.
//

import Foundation

/*
 * Creates new schedule with given `toBed` parameter and other parameters are unchanged from `currentSchedule`
 * Deletes old schedule from the storage
 * Saves new schedule to the storage
 */
protocol AdjustSchedule {
    func callAsFunction(
        currentSchedule schedule: Schedule,
        newToBed: Date
    )
    var mightNeedAdjustment: Bool { get }
}

final class AdjustScheduleImpl: AdjustSchedule {

    private let createSchedule: CreateSchedule
    private let scheduleRepository: ScheduleRepository
    private let userData: UserData

    private var adjusted = false
    var mightNeedAdjustment: Bool {
        if adjusted { return false }
        guard let latestAppUsageDate = userData.latestAppUsageDate,
              let days = calendar.dateComponents([.day], from: latestAppUsageDate, to: Date()).day else {
            return false
        }
        return days >= 2
    }

    init(_ createSchedule: CreateSchedule,
         _ scheduleRepository: ScheduleRepository,
         _ userData: UserData
    ) {
        self.createSchedule = createSchedule
        self.scheduleRepository = scheduleRepository
        self.userData = userData
    }

    func callAsFunction(
        currentSchedule schedule: Schedule,
        newToBed: Date
    ) {
        let newSchedule = createSchedule(
            wantedSleepDuration: schedule.sleepDuration,
            currentToBed: newToBed.normalised(with: schedule.toBed),
            wantedToBed: schedule.targetToBed,
            intensity: schedule.intensity
        )
        scheduleRepository.deleteAll()
        scheduleRepository.save(newSchedule)
        adjusted = true
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
