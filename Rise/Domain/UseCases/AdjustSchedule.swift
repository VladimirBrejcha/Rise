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

    init(_ scheduleRepository: ScheduleRepository,
         _ userData: UserData
    ) {
        self.scheduleRepository = scheduleRepository
        self.userData = userData
    }

    func callAsFunction(
        currentSchedule schedule: Schedule,
        newToBed: Date
    ) {
        let newSchedule = Schedule(
            sleepDuration: schedule.sleepDuration,
            intensity: schedule.intensity,
            toBed: newToBed,
            wakeUp: schedule.wakeUp,
            targetToBed: schedule.targetToBed,
            targetWakeUp: schedule.targetWakeUp
        )
        adjusted = true
        if newSchedule == schedule {
            log(.warning, "No changes, early return")
            return
        }
        scheduleRepository.deleteAll()
        scheduleRepository.save(newSchedule)
    }
}
