//
//  CreateSchedule.swift
//  Rise
//
//  Created by Vladimir Korolev on 06.11.2021.
//  Copyright © 2021 VladimirBrejcha. All rights reserved.
//

import Foundation

protocol CreateSchedule {
    func callAsFunction(
        wantedSleepDuration: Schedule.Minute,
        currentToBed: Date,
        wantedToBed: Date,
        intensity: Schedule.Intensity
    ) -> Schedule
}

final class CreateScheduleImpl: CreateSchedule {
    func callAsFunction(
        wantedSleepDuration: Schedule.Minute,
        currentToBed: Date,
        wantedToBed: Date,
        intensity: Schedule.Intensity
    ) -> Schedule {
        .init(
            sleepDuration: wantedSleepDuration,
            intensity: intensity,
            toBed: currentToBed,
            wakeUp: calculateWakeUp(
                toBed: currentToBed,
                sleepDuration: wantedSleepDuration
            ),
            targetToBed: wantedToBed
        )
    }

    private func calculateWakeUp(toBed: Date, sleepDuration: Schedule.Minute) -> Date {
        toBed
            .addingTimeInterval(days: -1)
            .addingTimeInterval(minutes: sleepDuration)
    }
}
