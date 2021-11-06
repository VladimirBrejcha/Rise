//
//  ScheduleTests.swift
//  RiseTests
//
//  Created by Vladimir Korolev on 31.10.2021.
//  Copyright © 2021 VladimirBrejcha. All rights reserved.
//

import XCTest
@testable import Rise

class ScheduleTests: XCTestCase {

    var createSchedule: CreateSchedule { CreateScheduleImpl() }
    var nextSchedule: CreateNextSchedule { CreateNextScheduleImpl() }

    let allDurations = Array((5 * 60)...(10 * 60))
    let allIntensities: [Schedule.Intensity] = [.low, .normal, .high]

    // MARK: - CreateSchedule

    func testCreateSchedule() {

        // Given

        let currentHours = Array(0...50)
        let wantedHours = Array(1...51)

        for duration in allDurations {
            for i in currentHours.indices {

                let currentHour = currentHours[i]
                let wantedHour = wantedHours[i]
                let intensity = allIntensities.randomElement()!
                let currentToBed = time(day: 1, hour: currentHour)
                let wantedTobed = time(day: 1, hour: wantedHour)

                // When

                let schedule = createSchedule(
                    wantedSleepDuration: duration,
                    currentToBed: currentToBed,
                    wantedToBed: wantedTobed,
                    intensity: intensity
                )

                // Then

                XCTAssertEqual(schedule.toBed, currentToBed)
                XCTAssertEqual(
                    schedule.wakeUp,
                    currentToBed
                        .addingTimeInterval(days: -1)
                        .addingTimeInterval(minutes: duration)
                )
                XCTAssertEqual(schedule.intensity, intensity)
                XCTAssertEqual(schedule.targetToBed, wantedTobed)
            }
        }
    }

    // MARK: - NegativeDiff

    func testNextScheduleNegativeDiff() {

        // Given

        let currentHours = Array(0...50)
        let wantedHours = Array(1...51)

        for duration in allDurations {

            for i in currentHours.indices {
                let currentHour = currentHours[i]

                for wantedHour in wantedHours[i...wantedHours.count - 1] {

                    let intensity: Schedule.Intensity = allIntensities.randomElement()!
                    let currentToBed = time(day: 1, hour: currentHour)
                    let wantedTobed = time(day: 1, hour: wantedHour)

                    let diff: Schedule.Minute = -(currentHour - wantedHour) * 60
                    let shift = max(diff / intensity.divider, intensity.minTimeShift)

                    let schedule = createSchedule(
                        wantedSleepDuration: duration,
                        currentToBed: currentToBed,
                        wantedToBed: wantedTobed,
                        intensity: intensity
                    )

                    testNextSchedule(schedule: schedule, shift: -shift)
                    testTargetReachable(schedule: schedule)
                }
            }
        }
    }

    // MARK: - PositiveDiff

    func testNextSchedulePositiveDiff() {

        // Given

        let currentHours = Array(1...70)
        let wantedHours = Array(0...69)

        for duration in allDurations {

            for i in currentHours.indices {

                let currentHour = currentHours[i]

                for wantedHour in wantedHours[0...i] {

                    let intensity: Schedule.Intensity = allIntensities.randomElement()!
                    let currentToBed = time(day: 1, hour: currentHour)
                    let wantedTobed = time(day: 1, hour: wantedHour)

                    let diff: Schedule.Minute = (currentHour - wantedHour) * 60
                    let shift = max(diff / intensity.divider, intensity.minTimeShift)

                    let schedule = createSchedule(
                        wantedSleepDuration: duration,
                        currentToBed: currentToBed,
                        wantedToBed: wantedTobed,
                        intensity: intensity
                    )

                    testNextSchedule(schedule: schedule, shift: shift)
                    testTargetReachable(schedule: schedule)
                }
            }
        }
    }

    // MARK: - Nodiff

    func testNextScheduleNoDiff() {

        // Given

        let currentHours = Array(0...70)
        let wantedHours = Array(0...70)

        for duration in allDurations {

            for i in currentHours.indices {

                let currentHour = currentHours[i]
                let wantedHour = wantedHours[i]
                let intensity: Schedule.Intensity = allIntensities.randomElement()!
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

                XCTAssertEqual(nextSchedule.toBed, schedule.toBed.appending(days: 1))
                XCTAssertEqual(nextSchedule.toBed, nextSchedule.targetToBed)
                XCTAssertEqual(nextSchedule.wakeUp, schedule.wakeUp.appending(days: 1))
                XCTAssertEqual(nextSchedule.targetToBed, schedule.targetToBed.appending(days: 1))
            }
        }
    }

    // MARK: - Reused

    func testNextSchedule(schedule: Schedule, shift: Schedule.Minute) {

        // When

        let nextSchedule = nextSchedule(from: schedule)

        // Then

        XCTAssertEqual(
            nextSchedule.targetToBed,
            schedule.targetToBed
                .addingTimeInterval(days: 1)
        )
        XCTAssertEqual(
            nextSchedule.toBed,
            schedule.toBed
                .addingTimeInterval(days: 1)
                .addingTimeInterval(minutes: -shift),
            """

                current: \(schedule.toBed)
                next: \(nextSchedule.toBed)
                expected: \(schedule.toBed.addingTimeInterval(days: 1).addingTimeInterval(minutes: -shift))
                shift: \(-shift)
            """
        )
        XCTAssertEqual(
            nextSchedule.wakeUp,
            schedule.wakeUp
                .addingTimeInterval(days: 1)
                .addingTimeInterval(minutes: -shift)
        )
    }

    func testTargetReachable(schedule: Schedule) {

        // When

        var next: Schedule = nextSchedule(from: schedule)

        var counter = 0
        while (next.toBed != next.targetToBed) {
            next = nextSchedule(from: next)

            // Then

            XCTAssert(
                counter <= schedule.intensity.divider * 5,
                """

                counter: \(counter)
                intensity: \(next.intensity)
                target: \(next.targetToBed)
                next: \(next.toBed)
                """
            )

            if schedule.targetToBed > schedule.toBed {
                XCTAssertTrue(next.toBed <= next.targetToBed)
            } else {
                XCTAssertTrue(next.toBed >= next.targetToBed)
            }

            counter += 1
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
