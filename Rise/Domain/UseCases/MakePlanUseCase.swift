//
//  MakePlan.swift
//  Rise
//
//  Created by Владимир Королев on 05.01.2020.
//  Copyright © 2020 VladimirBrejcha. All rights reserved.
//

import Foundation

protocol MakePlan {
    func callAsFunction(sleepDurationMin: Int,
                        wakeUpTime: Date,
                        planDurationDays: Int,
                        firstSleepTime: Date) throws
}

final class MakePlanUseCase: MakePlan {
    private let planRepository: RisePlanRepository
    
    init(_ planRepository: RisePlanRepository) {
        self.planRepository = planRepository
    }
    
    func callAsFunction(sleepDurationMin: Int,
                        wakeUpTime: Date,
                        planDurationDays: Int,
                        firstSleepTime: Date
    ) throws {
        guard let firstSleepTime = firstSleepTime.zeroSeconds
            else {
                throw InternalError.dateBuildingError
        }
        let dateInterval = try calculateDateInterval(since: firstSleepTime, with: planDurationDays)
        guard let wakeUpTime = calendar.date(bySettingHour: calendar.component(.hour, from: wakeUpTime),
                                             minute: calendar.component(.minute, from: wakeUpTime),
                                             second: 00,
                                             of: dateInterval.end)
            else {
                throw InternalError.dateBuildingError
        }
        
        let sleepDurationSec = sleepDurationMin.toSeconds()
        let finalSleepTime = wakeUpTime.appending(days: 1).addingTimeInterval(-sleepDurationSec)
        
        let dailyShift = calculateTimeShift(from: firstSleepTime, to: finalSleepTime, with: planDurationDays)
        
        try planRepository.save(plan:
            RisePlan(
                dateInterval: dateInterval,
                firstSleepTime: firstSleepTime,
                finalWakeUpTime: wakeUpTime,
                sleepDurationSec: sleepDurationSec,
                dailyShiftMin: dailyShift,
                latestConfirmedDay: dateInterval.start,
                daysMissed: 0,
                paused: false)
        )
    }
    
    // MARK: - Private -
    private func calculateTimeShift(from firstSleepTime: Date, to finalSleepTime: Date, with durationDays: Int) -> Int {
        let adjustedFinalSleepTime = finalSleepTime.appending(days: -durationDays)
        return firstSleepTime > adjustedFinalSleepTime
            ? -(firstSleepTime.timeIntervalSince(adjustedFinalSleepTime).toMinutes() / durationDays)
            : adjustedFinalSleepTime.timeIntervalSince(firstSleepTime).toMinutes() / durationDays
    }
    
    private func calculateDateInterval(since firstSleepTime: Date, with duration: Int) throws -> DateInterval {
        guard let nightDate = calendar.date(bySettingHour: 00, minute: 0, second: 0, of: firstSleepTime)
            else {
                throw InternalError.dateBuildingError
        }
        guard let noonDate = calendar.date(bySettingHour: 12, minute: 0, second: 0, of: firstSleepTime)
            else {
                throw InternalError.dateBuildingError
        }
        let startDay = firstSleepTime > nightDate && firstSleepTime < noonDate
            ? firstSleepTime.noon.appending(days: -1)
            : firstSleepTime.noon
        let endDay = startDay.appending(days: duration)
        return DateInterval(start: startDay, end: endDay)
    }
}
