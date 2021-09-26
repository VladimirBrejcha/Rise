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
    let targetWakeUpTime: Date
    let targetSleepDurationMin: Int
    // startingToBedTime must have correct day
    // to bed time of the first scheduled day
    let startingToBedTime: Date
    // the day schedule is created
    // must be nooned
    let startDate: Date
    // the day schedule will reach its target 
    // must be nooned
    let finishDate: Date
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
        if calendar.isDate(date, inSameDayAs: schedule.startDate) {
            return .init(wakeUp: nil, toBed: schedule.startingToBedTime)
        }

        return nil
    }
}

class RiseScheduleTests: XCTestCase {

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

    func testCalculateScheduledTimeVariousDays() {

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
            NoonedDay.tomorrow.date,
        ].forEach { date in

            // When

            let dailyTime = calculateScheduledTime(for: date)

            // Then

            guard let dailyTime = dailyTime else {
                XCTAssert(false)
                return
            }

            let dailyTimeShift =

            dailyTime.toBed

            guard let wakeUp = dailyTime.wakeUp else {
                XCTAssert(false)
                return
            }


        }
    }



    // MARK: - Utils -

    private let calendar = Calendar.current
    private let today = Date()

    private func date(byAddingDays: Int, bySettingsHours: Int, bySettingMins: Int, to date: Date) -> Date {
        guard let dateAddedDay = calendar.date(byAdding: .day, value: 1, to: date),
              let dateSettedHour = calendar.date(bySetting: .hour, value: 3, of: dateAddedDay),
              let dateSettedMins = calendar.date(bySetting: .minute, value: 0, of: dateSettedHour)
        else {
            fatalError()
        }
        return dateSettedMins
    }

    private func basicSchedule(start: Date, startToBed: Date) -> Schedule {
        .init(
            targetWakeUpTime: .init(hour: 8, minute: 0),
            targetSleepDurationMin: 8,
            startingToBedTime: startToBed,
            startDate: start
        )
    }
}
