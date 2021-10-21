//
//  RiseTests.swift
//  RiseTests
//
//  Created by Vladimir Korolev on 11.01.2020.
//  Copyright © 2020 VladimirBrejcha. All rights reserved.
//

import XCTest
@testable import Rise

struct ScheduledTime {
    // may be `nil` if is of the same day as a `Schedule.startDate`
    let wakeUp: Date?
    let toBed: Date
}

// reconfigure on each completed day, change startDate to today, change startingToBedTime to completed toBedTime
struct Schedule {
    // the day schedule will reach its target
    // and the time of final wakeUp
    let targetWakeUpTime: Date
    let targetSleepDurationMin: Int
    // startingToBedTime must have correct day
    // to bed time of the first scheduled day
    let startingToBedTime: Date
    // the day schedule is created
    // must be nooned
    let startDate: Date
}

protocol CalculateScheduledTime {
    // returns `nil` if `date` argument is earlier than `Schedule.startDay` for 1 day or more
    func callAsFunction(for date: Date) -> ScheduledTime?
}

final class CalculateScheduledTimeImpl: CalculateScheduledTime {

    private let schedule: Schedule
    private let calendar = Calendar.current

    init(schedule: Schedule) {
        self.schedule = schedule
    }

    func callAsFunction(for date: Date) -> ScheduledTime? {
        let noonedDate = date.noon

        if calendar.isDate(noonedDate, inSameDayAs: schedule.startDate) {
            return .init(wakeUp: nil, toBed: schedule.startingToBedTime)
        }

        if noonedDate < schedule.startDate {
            return nil
        }

        if calendar.isDate(noonedDate, inSameDayAs: schedule.targetWakeUpTime)
            || noonedDate > schedule.targetWakeUpTime {

            let wakeUp = calendar.date(
                bySettingHour: calendar.dateComponents([.hour], from: schedule.targetWakeUpTime).hour!,
                minute: calendar.dateComponents([.minute], from: schedule.targetWakeUpTime).minute!,
                second: 0,
                of: noonedDate
            ).safe

            let toBed = wakeUp.addingTimeInterval(
                minutes: -schedule.targetSleepDurationMin + (24 * 60)
            )

            return .init(
                wakeUp: wakeUp,
                toBed: toBed
            )
        }

        let daysDiff = calendar.dateComponents(
            [.day],
            from: schedule.startDate.noon,
            to: schedule.targetWakeUpTime.noon
        ).day!

        let finalToBed = schedule.targetWakeUpTime
            .addingTimeInterval(minutes: -schedule.targetSleepDurationMin)
            .appending(days: 1)

        let finalToBedWithoutDays = finalToBed
            .addingTimeInterval(minutes: -daysDiff * 24 * 60)
            .appending(days: -1)

        let diffMins = (schedule.startingToBedTime.timeIntervalSince1970 - finalToBedWithoutDays.timeIntervalSince1970) / 60

        let dailyShiftMin = Int(diffMins) / daysDiff

        let daysSincePlanStart = DateInterval(start: schedule.startDate, end: date).durationDays

        return .init(
            wakeUp: schedule.targetWakeUpTime.addingTimeInterval(minutes: (-(daysDiff - daysSincePlanStart) * 24 * 60) + ((daysDiff - daysSincePlanStart) * dailyShiftMin)),
            toBed: schedule.startingToBedTime.addingTimeInterval(minutes: (daysSincePlanStart * 24 * 60) - (dailyShiftMin * daysSincePlanStart))
        )
    }

    private func calculateTimeShift(from firstSleepTime: Date, to finalSleepTime: Date, with durationDays: Int) -> Int {
        let adjustedFinalSleepTime = finalSleepTime.appending(days: -durationDays)
        return firstSleepTime > adjustedFinalSleepTime
            ? -(firstSleepTime.timeIntervalSince(adjustedFinalSleepTime).toMinutes() / durationDays)
            : adjustedFinalSleepTime.timeIntervalSince(firstSleepTime).toMinutes() / durationDays
    }
}

extension Optional where Wrapped == Date {
    var safe: Date {
        if case let .some(date) = self {
            return date
        } else {
            assertionFailure()
            return Date()
        }
    }
}

class RiseScheduleTests: XCTestCase {

    // MARK: - CalculateScheduledTime Tests -

    func testCalculateScheduledTimeToSleepOnNextDay() {
        let numberOfDaysInSchedule = 10

        let startDate = time(day: 1, hour: 12, min: 0)
        let startingToBedTime = time(day: 2, hour: 3, min: 0)
        let targetWakeUpTime = time(day: numberOfDaysInSchedule + 1, hour: 8, min: 0)
        let targetSleepDurationMin = 8 * 60

        let diffMins = 180
        let dailyShiftMin = diffMins / numberOfDaysInSchedule

        let schedule = Schedule(
            targetWakeUpTime: targetWakeUpTime,
            targetSleepDurationMin: targetSleepDurationMin,
            startingToBedTime: startingToBedTime,
            startDate: startDate
        )

        runCalculateScheduleTests(
            schedule: schedule,
            numberOfDaysInSchedule: numberOfDaysInSchedule,
            dailyShiftMin: dailyShiftMin
        )
    }

    func testCalculateScheduledTimeToSleepOnSameDay() {
        let numberOfDaysInSchedule = 10

        let startDate = time(day: 1, hour: 12, min: 0)
        let startingToBedTime = time(day: 1, hour: 13, min: 0)
        let targetWakeUpTime = time(day: numberOfDaysInSchedule + 1, hour: 18, min: 0)
        let targetSleepDurationMin = 8 * 60

        let diffMins = 180
        let dailyShiftMin = diffMins / numberOfDaysInSchedule

        let schedule = Schedule(
            targetWakeUpTime: targetWakeUpTime,
            targetSleepDurationMin: targetSleepDurationMin,
            startingToBedTime: startingToBedTime,
            startDate: startDate
        )

        runCalculateScheduleTests(
            schedule: schedule,
            numberOfDaysInSchedule: numberOfDaysInSchedule,
            dailyShiftMin: dailyShiftMin
        )
    }

    func testCalculateScheduledTimeNoDiff() {
        let numberOfDaysInSchedule = 10

        let startDate = time(day: 1, hour: 12, min: 0)
        let startingToBedTime = time(day: 1, hour: 23, min: 0)
        let targetWakeUpTime = time(day: numberOfDaysInSchedule + 1, hour: 7, min: 0)
        let targetSleepDurationMin = 8 * 60

        let dailyShiftMin = 0

        let schedule = Schedule(
            targetWakeUpTime: targetWakeUpTime,
            targetSleepDurationMin: targetSleepDurationMin,
            startingToBedTime: startingToBedTime,
            startDate: startDate
        )

        runCalculateScheduleTests(
            schedule: schedule,
            numberOfDaysInSchedule: numberOfDaysInSchedule,
            dailyShiftMin: dailyShiftMin
        )
    }

//    func testCalculateScheduledTimeNegativeDiff() {
//        let numberOfDaysInSchedule = 10
//
//        let startDate = time(day: 1, hour: 12, min: 0)
//        let startingToBedTime = time(day: 1, hour: 23, min: 0)
//        let targetWakeUpTime = time(day: numberOfDaysInSchedule + 1, hour: 7, min: 0)
//        let targetSleepDurationMin = 8 * 60
//
//        let dailyShiftMin = 0
//
//        let schedule = Schedule(
//            targetWakeUpTime: targetWakeUpTime,
//            targetSleepDurationMin: targetSleepDurationMin,
//            startingToBedTime: startingToBedTime,
//            startDate: startDate
//        )
//
//        runCalculateScheduleTests(
//            schedule: schedule,
//            numberOfDaysInSchedule: numberOfDaysInSchedule,
//            dailyShiftMin: dailyShiftMin
//        )
//    }

    func runCalculateScheduleTests(
        schedule: Schedule,
        numberOfDaysInSchedule: Int,
        dailyShiftMin: Int
    ) {
        calculateScheduledTimeBeforeStartDate(schedule: schedule)
        calculateScheduledTimeVariousDays(
            schedule: schedule,
            numberOfDaysInSchedule: numberOfDaysInSchedule,
            dailyShiftMin: dailyShiftMin
        )
        calculateScheduledTimeEndDayAndAfter(
            schedule: schedule,
            numberOfDaysInSchedule: numberOfDaysInSchedule
        )
    }

    func calculateScheduledTimeBeforeStartDate(
        schedule: Schedule
    ) {
        // Given

        let calculateScheduledTime: CalculateScheduledTime = CalculateScheduledTimeImpl(
            schedule: schedule
        )

        [
            schedule.startDate.appending(days: -1),
            schedule.startDate.addingTimeInterval(-60 * 60 * 24),
            schedule.startDate.appending(days: -2)
        ]
        .forEach {

            // When

            let dailyTime = calculateScheduledTime(for: $0)

            // Then

            XCTAssertNil(dailyTime)
        }
    }

    func calculateScheduledTimeEndDayAndAfter(
        schedule: Schedule,
        numberOfDaysInSchedule: Int
    ) {
        // Given

        let calculateScheduledTime: CalculateScheduledTime = CalculateScheduledTimeImpl(
            schedule: schedule
        )

        for day in (numberOfDaysInSchedule...numberOfDaysInSchedule + 100) {

            // When

            let date = schedule.startDate.appending(days: day).noon
            let dailyTime = calculateScheduledTime(for: date)

            // Then

            guard let dailyTime = dailyTime else {
                XCTAssert(false)
                return
            }

            guard let wakeUp = dailyTime.wakeUp else {
                XCTAssert(false)
                return
            }

            XCTAssertEqual(
                calendar.dateComponents([.hour, .minute], from: wakeUp),
                calendar.dateComponents([.hour, .minute], from: schedule.targetWakeUpTime)
            )

            guard let expectedToBed = calendar.date(
                byAdding: .minute, value: -schedule.targetSleepDurationMin,
                to: schedule.targetWakeUpTime
            ) else {
                XCTAssert(false)
                return
            }

            XCTAssertEqual(
                calendar.dateComponents([.hour, .minute], from: dailyTime.toBed),
                calendar.dateComponents([.hour, .minute], from: expectedToBed)
            )
        }
    }

    func calculateScheduledTimeVariousDays(
        schedule: Schedule,
        numberOfDaysInSchedule: Int,
        dailyShiftMin: Int
    ) {
        // Given

        let calculateScheduledTime: CalculateScheduledTime = CalculateScheduledTimeImpl(
            schedule: schedule
        )

        for day in (numberOfDaysInSchedule...numberOfDaysInSchedule) {

            // When

            let date = schedule.startDate.appending(days: day).noon
            let dailyTime = calculateScheduledTime(for: date)

            // Then

            guard let dailyTime = dailyTime else {
                XCTAssert(false)
                return
            }

            XCTAssertEqual(
                dailyTime.toBed.timeIntervalSince1970,
                schedule.startingToBedTime.timeIntervalSince1970
                    + Double((day * 24 * 60 * 60) - (day * dailyShiftMin * 60)),
                "day number = \(day)"
            )

            if day == 0 {
                XCTAssertNil(dailyTime.wakeUp)
                continue
            }

            guard let wakeUp = dailyTime.wakeUp else {
                XCTAssert(false)
                return
            }

            XCTAssertEqual(
                wakeUp.timeIntervalSince1970,
                schedule.targetWakeUpTime.timeIntervalSince1970
                    - Double(((10 - day) * 24 * 60 * 60) - (dailyShiftMin * 60 * (10 - day)))
            )
        }
    }



    // MARK: - Utils -

    private let calendar = Calendar.current
    private let today = Date()

    private func date(
        byAddingDays days: Int,
        bySettingsHours hours: Int,
        bySettingMins mins: Int,
        to date: Date
    ) -> Date {
        guard let dateAddedDay = calendar.date(byAdding: .day, value: days, to: date),
              let dateSettedHour = calendar.date(bySetting: .hour, value: hours, of: dateAddedDay),
              let dateSettedMins = calendar.date(bySetting: .minute, value: mins, of: dateSettedHour)
        else {
            fatalError()
        }
        return dateSettedMins
    }

    private func time(day: Int, hour: Int, min: Int) -> Date {
        calendar.date(
            from: .init(
                year: 2021,
                month: 1,
                day: day,
                hour: hour,
                minute: min
            )
        )!
    }
}
