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

        if calendar.isDate(noonedDate, inSameDayAs: schedule.targetWakeUpTime) {
            return .init(
                wakeUp: schedule.targetWakeUpTime,
                toBed: calendar.date(
                    byAdding: .minute,
                    value: -schedule.targetSleepDurationMin,
                    to: schedule.targetWakeUpTime
                ).safe
            )
        }

        return nil
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

    // MARK: - Tests -

    func testCalculateScheduledTimeBeforeStartDate() {

        // Given

        let startDate = NoonedDay.today.date
        let startingToBedTime = date(
            byAddingDays: 1,
            bySettingsHours: 3,
            bySettingMins: 0,
            to: startDate
        )
        let calculateScheduledTime: CalculateScheduledTime = CalculateScheduledTimeImpl(
            schedule: basicSchedule(start: startDate, startToBed: startingToBedTime)
        )
        [
            startDate.appending(days: -1),
            startDate.addingTimeInterval(-60 * 60 * 24),
            startDate.appending(days: -2)
        ]
        .forEach {

            // When

            let dailyTime = calculateScheduledTime(for: $0)

            // Then

            XCTAssertNil(dailyTime)
        }
    }

    func testCalculateScheduledTimeStartDay() {

        // Given

        let startDate = NoonedDay.today.date
        let startingToBedTime = date(
            byAddingDays: 1,
            bySettingsHours: 3,
            bySettingMins: 0,
            to: startDate
        )
        let calculateScheduledTime: CalculateScheduledTime = CalculateScheduledTimeImpl(
            schedule: basicSchedule(start: startDate, startToBed: startingToBedTime)
        )
        let todayComponents = calendar.dateComponents([.year, .month, .day], from: today)
        [
            today,
            NoonedDay.today.date,
            calendar.date(from: .init(
                year: todayComponents.year,
                month: todayComponents.month,
                day: todayComponents.day
            ))!
        ].forEach { date in

            // When

            let dailyTime = calculateScheduledTime(for: date)

            // Then

            guard let dailyTime = dailyTime else {
                XCTAssert(false)
                return
            }

            XCTAssertNil(dailyTime.wakeUp)

            let toBed = dailyTime.toBed

            XCTAssertEqual(
                calendar.component(.hour, from: toBed),
                calendar.component(.hour, from: startingToBedTime)
            )

            XCTAssertEqual(
                calendar.component(.minute, from: toBed),
                calendar.component(.minute, from: startingToBedTime)
            )
        }
    }

    func testCalculateScheduledTimeEndDay() {

        // Given

        let startDate = NoonedDay.today.date
        let startingToBedTime = date(
            byAddingDays: 1,
            bySettingsHours: 3,
            bySettingMins: 0,
            to: startDate
        )
        let targetWakeUpTime = date(
            byAddingDays: 30,
            bySettingsHours: 8,
            bySettingMins: 0,
            to: startDate
        )
        let targetSleepDurationMin = 8 * 60

        let calculateScheduledTime: CalculateScheduledTime = CalculateScheduledTimeImpl(
            schedule: .init(
                targetWakeUpTime: targetWakeUpTime,
                targetSleepDurationMin: targetSleepDurationMin,
                startingToBedTime: startingToBedTime,
                startDate: startDate
            )
        )

        // When

        let dailyTime = calculateScheduledTime(for: targetWakeUpTime)

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
            calendar.dateComponents([.day, .hour, .minute], from: wakeUp),
            calendar.dateComponents([.day, .hour, .minute], from: targetWakeUpTime)
        )

        guard let expectedToBed = calendar.date(
            byAdding: .minute, value: -targetSleepDurationMin,
            to: targetWakeUpTime
        ) else {
            XCTAssert(false)
            return
        }

        XCTAssertEqual(
            calendar.dateComponents([.day, .hour, .minute], from: dailyTime.toBed),
            calendar.dateComponents([.day, .hour, .minute], from: expectedToBed)
        )
    }

    func testCalculateScheduledTimeVariousDays() {

        // Given

        let startDate = NoonedDay.today.date
        let startingToBedTime = date(
            byAddingDays: 1,
            bySettingsHours: 3,
            bySettingMins: 0,
            to: startDate
        )
        let targetWakeUpTime = date(
            byAddingDays: 30,
            bySettingsHours: 8,
            bySettingMins: 0,
            to: startDate
        )
        let targetSleepDurationMin = 8 * 60

        let calculateScheduledTime: CalculateScheduledTime = CalculateScheduledTimeImpl(
            schedule: .init(
                targetWakeUpTime: targetWakeUpTime,
                targetSleepDurationMin: targetSleepDurationMin,
                startingToBedTime: startingToBedTime,
                startDate: startDate
            )
        )

        let firstWakeUp = startingToBedTime.addingTimeInterval(TimeInterval(targetSleepDurationMin * 60))
        let lastWakeUp = calendar.date(
            bySettingHour: 8,
            minute: 0,
            second: 0,
            of: firstWakeUp
        )!
        let diff = (firstWakeUp.timeIntervalSince1970 - lastWakeUp.timeIntervalSince1970) / 60

        let daysDiff = calendar.dateComponents([.day], from: startDate, to: targetWakeUpTime).day!

        let dailyShiftMin = Int(diff) / daysDiff

        [
            NoonedDay.tomorrow.date,
        ].forEach { date in

            // When

            let dailyTime = calculateScheduledTime(for: date)

            // Then

            guard let dailyTime = dailyTime else {
                XCTAssert(false)
                return
            }

            XCTAssertEqual(
                calendar.dateComponents([.minute], from: dailyTime.toBed).minute,
                calendar.dateComponents([.minute], from: startingToBedTime).minute! - dailyShiftMin
            )

            guard let wakeUp = dailyTime.wakeUp else {
                XCTAssert(false)
                return
            }
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

    private func basicSchedule(start: Date, startToBed: Date) -> Schedule {
        .init(
            targetWakeUpTime: date(byAddingDays: 30, bySettingsHours: 8, bySettingMins: 0, to: start),
            targetSleepDurationMin: 8 * 60,
            startingToBedTime: startToBed,
            startDate: start
        )
    }
}
