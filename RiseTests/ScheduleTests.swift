//
//  ScheduleTests.swift
//  RiseTests
//
//  Created by Vladimir Korolev on 31.10.2021.
//  Copyright © 2021 VladimirBrejcha. All rights reserved.
//

import XCTest
@testable import Rise

typealias Minute = Int

extension Minute {
    init(timeInterval: TimeInterval) {
        self = Int(timeInterval) / 60
    }
}

extension Date {
    func addingTimeInterval(days: Int) -> Date {
        addingTimeInterval(TimeInterval(days * 24 * 60 * 60))
    }
}

// MARK: - Schedule

struct NewSchedule {
    let sleepDuration: Minute
    let intensity: Intensity
    let currentToBed: Date
    let targetToBed: Date
}

extension NewSchedule {
    enum Intensity {
        case low
        case normal
        case high

        var divider: Int {
            switch self {
            case .low:
                return 40
            case .normal:
                return 25
            case .high:
                return 10
            }
        }
    }
}

// MARK: - CreateSchedule

protocol CreateSchedule {
    func callAsFunction(
        wantedSleepDuration: Minute,
        currentToBed: Date,
        wantedToBed: Date,
        intensity: NewSchedule.Intensity
    ) -> NewSchedule
}

final class CreateScheduleImpl: CreateSchedule {
    func callAsFunction(
        wantedSleepDuration: Minute,
        currentToBed: Date,
        wantedToBed: Date,
        intensity: NewSchedule.Intensity
    ) -> NewSchedule {
        .init(
            sleepDuration: wantedSleepDuration,
            intensity: intensity,
            currentToBed: currentToBed,
            targetToBed: wantedToBed
        )
    }
}

// MARK: - NextSchedule

protocol NextSchedule {
    func callAsFunction(from schedule: NewSchedule) -> NewSchedule
}

final class NextScheduleImpl: NextSchedule {

    func callAsFunction(from schedule: NewSchedule) -> NewSchedule {
        .init(
            sleepDuration: schedule.sleepDuration,
            intensity: schedule.intensity,
            currentToBed: calculateNextToBed(
                current: schedule.currentToBed,
                target: schedule.targetToBed,
                intensity: schedule.intensity
            ),
            targetToBed: incrementDay(
                old: schedule.targetToBed
            )
        )
    }

    private func calculateNextToBed(
        current: Date,
        target: Date,
        intensity: NewSchedule.Intensity
    ) -> Date {
        incrementDay(
            old: createNewCurrentToBed(
                old: current,
                timeShift: selectTimeShift(
                    total: calculateDiff(
                        current: current,
                        target: target
                    ),
                    intensity: intensity
                )
            )
        )
    }

    private func calculateDiff(current: Date, target: Date) -> Minute {
        .init(
            timeInterval: abs(current.timeIntervalSince1970 - target.timeIntervalSince1970)
        )
    }

    private func selectTimeShift(total: Minute, intensity: NewSchedule.Intensity) -> Minute {
        if total == 0 { return 0 }
        return total / intensity.divider
    }

    private func createNewCurrentToBed(old: Date, timeShift: Minute) -> Date {
        old.addingTimeInterval(minutes: timeShift)
    }

    private func incrementDay(old: Date) -> Date {
        old.addingTimeInterval(days: 1)
    }

    private func decrementDay(old: Date) -> Date {
        old.addingTimeInterval(days: -1)
    }
}

extension NewSchedule.Intensity: CaseIterable { }
extension NewSchedule: Equatable { }

class ScheduleTests: XCTestCase {

    var createSchedule: CreateSchedule { CreateScheduleImpl() }
    var nextSchedule: NextSchedule { NextScheduleImpl() }

    let allDurations = Array((5 * 60)...(10 * 60))

    // MARK: - AnotherSchedule Tests

    // MARK: - With diff

    func testScheduleNegativeDiff() {

        // Given

        let currentHours = Array(0...50)
        let wantedHours = Array(1...51)
        let intensitys = NewSchedule.Intensity.allCases

        for duration in allDurations {

            for i in currentHours.indices {
                let currentHour = currentHours[i]

                for wantedHour in wantedHours[i...wantedHours.count - 1] {

                    let intensity: NewSchedule.Intensity = intensitys.randomElement()!
                    let currentToBed = time(day: 1, hour: currentHour)
                    let wantedTobed = time(day: 1, hour: wantedHour)

                    let diff: Minute = -(currentHour - wantedHour) * 60
                    let shift = diff / intensity.divider

                    let schedule = createSchedule(
                        wantedSleepDuration: duration,
                        currentToBed: currentToBed,
                        wantedToBed: wantedTobed,
                        intensity: intensity
                    )

                    testNextSchedule(schedule: schedule, shift: shift)
                }
            }
        }
    }

    func testSchedulePositiveDiff() {

        // Given

        let currentHours = Array(1...70)
        let wantedHours = Array(0...69)
        let intensitys = NewSchedule.Intensity.allCases

        for duration in allDurations {

            for i in currentHours.indices {

                let currentHour = currentHours[i]

                for wantedHour in wantedHours[0...i] {

                    let intensity: NewSchedule.Intensity = intensitys.randomElement()!
                    let currentToBed = time(day: 1, hour: currentHour)
                    let wantedTobed = time(day: 1, hour: wantedHour)

                    let diff: Minute = (currentHour - wantedHour) * 60
                    let shift = diff / intensity.divider

                    let schedule = createSchedule(
                        wantedSleepDuration: duration,
                        currentToBed: currentToBed,
                        wantedToBed: wantedTobed,
                        intensity: intensity
                    )

                    testNextSchedule(schedule: schedule, shift: shift)
                }
            }
        }
    }

    func testNextSchedule(schedule: NewSchedule, shift: Minute) {

        // When

        let nextSchedule = nextSchedule(from: schedule)

        // Then

        XCTAssertEqual(
            nextSchedule.targetToBed,
            schedule.targetToBed
                .addingTimeInterval(days: 1)
        )
        XCTAssertEqual(
            nextSchedule.currentToBed,
            schedule.currentToBed
                .addingTimeInterval(days: 1)
                .addingTimeInterval(minutes: shift),
            """

                current: \(schedule.currentToBed)
                next: \(nextSchedule.currentToBed)
                expected: \(schedule.currentToBed.addingTimeInterval(days: 1).addingTimeInterval(minutes: shift))
                shift: \(shift)
            """
        )
    }

    // MARK: - No diff

    func testNextScheduleNoDiff() {

        // Given

        let currentHours = Array(0...70)
        let wantedHours = Array(0...70)
        let intensitys = NewSchedule.Intensity.allCases

        for duration in allDurations {

            for i in currentHours.indices {

                let currentHour = currentHours[i]
                let wantedHour = wantedHours[i]
                let intensity: NewSchedule.Intensity = intensitys.randomElement()!
                let currentToBed = time(day: 1, hour: currentHour)
                let wantedTobed = time(day: 1, hour: wantedHour)

                let schedule = createSchedule(
                    wantedSleepDuration: duration,
                    currentToBed: currentToBed,
                    wantedToBed: wantedTobed,
                    intensity: intensity
                )

                // When

                let nextSchedule = nextSchedule(from: schedule)

                // Then

                XCTAssertEqual(schedule.currentToBed, nextSchedule.currentToBed.appending(days: -1))
                XCTAssertEqual(schedule.targetToBed, nextSchedule.targetToBed.appending(days: -1))
            }
        }
    }

    // MARK: - Utils -

    private func time(
        year: Int = 2021,
        month: Int = 1,
        day: Int,
        hour: Int,
        min: Int = 0
    ) -> Date {
        Calendar.current.date(
            from: .init(
                year: year,
                month: month,
                day: day,
                hour: hour,
                minute: min
            )
        )!
    }
}
