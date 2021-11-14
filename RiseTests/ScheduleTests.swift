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
    var nextSchedule: CreateNextSchedule { CreateNextScheduleImpl(DefaultUserData()) }
    var updateSchedule: UpdateSchedule {
        UpdateScheduleImpl(createSchedule, scheduleRepository)
    }
    var getSchedule: GetSchedule {
        GetScheduleImpl(scheduleRepository, nextSchedule)
    }
    var scheduleRepository = ScheduleRepositoryMock()

    let allDurations = Array((5 * 60)...(10 * 60))
    let allIntensities: [Schedule.Intensity] = [.low, .normal, .high]

    // MARK: - Setup | Teardown

    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
        scheduleRepository.getForDateHandler = nil
        scheduleRepository.getLatestHandler = nil
        scheduleRepository.saveHandler = nil
        scheduleRepository.deleteAllHandler = nil
    }

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
                XCTAssertEqual(
                    schedule.targetWakeUp,
                    wantedTobed
                        .addingTimeInterval(days: -1)
                        .addingTimeInterval(minutes: duration)
                )
            }
        }
    }

    // MARK: - CreateNextSchedule -

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

                XCTAssertEqual(nextSchedule.toBed, schedule.toBed.addingTimeInterval(days: 1))
                XCTAssertEqual(nextSchedule.toBed, nextSchedule.targetToBed)
                XCTAssertEqual(nextSchedule.wakeUp, schedule.wakeUp.addingTimeInterval(days: 1))
                XCTAssertEqual(nextSchedule.targetToBed, schedule.targetToBed.addingTimeInterval(days: 1))
                XCTAssertEqual(nextSchedule.targetWakeUp, schedule.targetWakeUp.addingTimeInterval(days: 1))
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
            nextSchedule.targetWakeUp,
            schedule.targetWakeUp
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

    // MARK: - UpdateSchedule

    func testUpdateScheduleNoEdit() {

        // Given

        let schedule = Schedule(
            sleepDuration: 8 * 60,
            intensity: .normal,
            toBed: time(day: 1, hour: 23),
            wakeUp: time(day: 1, hour: 7),
            targetToBed: time(day: 1, hour: 23),
            targetWakeUp: time(day: 1, hour: 7)
        )

        var newSchedule: Schedule?
        let saveExpectation = expectation(description: "save")
        let deleteExpectation = expectation(description: "delete")
        scheduleRepository.saveHandler = handleSave
        scheduleRepository.deleteAllHandler = handleDeleteAll

        // When

        updateSchedule.callAsFunction(
            current: schedule,
            newSleepDuration: nil,
            newToBed: nil
        )

        // Then

        func handleSave(_ schedule: Schedule) {
            newSchedule = schedule
            saveExpectation.fulfill()
        }

        func handleDeleteAll() {
            deleteExpectation.fulfill()
        }

        waitForExpectations(timeout: 1) { error in
            if let error = error {
                XCTFail(error.localizedDescription)
                return
            }
            XCTAssertEqual(newSchedule, schedule)
        }
    }

    func testUpdateScheduleEditSleepDuration() {

        // Given

        let schedule = Schedule(
            sleepDuration: 8 * 60,
            intensity: .normal,
            toBed: time(day: 1, hour: 23),
            wakeUp: time(day: 1, hour: 7),
            targetToBed: time(day: 1, hour: 23),
            targetWakeUp: time(day: 1, hour: 7)
        )
        let newSleepDuration = 7 * 60
        let diffMins = -60

        var newSchedule: Schedule?
        let saveExpectation = expectation(description: "save")
        let deleteExpectation = expectation(description: "delete")
        scheduleRepository.saveHandler = handleSave
        scheduleRepository.deleteAllHandler = handleDeleteAll

        // When

        updateSchedule.callAsFunction(
            current: schedule,
            newSleepDuration: newSleepDuration,
            newToBed: nil
        )

        // Then

        func handleSave(_ schedule: Schedule) {
            newSchedule = schedule
            saveExpectation.fulfill()
        }

        func handleDeleteAll() {
            deleteExpectation.fulfill()
        }

        waitForExpectations(timeout: 1) { error in
            if let error = error {
                XCTFail(error.localizedDescription)
                return
            }

            XCTAssertEqual(newSchedule?.sleepDuration, newSleepDuration)
            XCTAssertEqual(newSchedule?.intensity, schedule.intensity)
            XCTAssertEqual(newSchedule?.targetToBed, schedule.targetToBed)
            XCTAssertEqual(
                newSchedule?.targetWakeUp,
                schedule.targetWakeUp.addingTimeInterval(minutes: diffMins)
            )
            XCTAssertEqual(newSchedule?.toBed, schedule.toBed)
            XCTAssertEqual(
                newSchedule?.wakeUp,
                schedule.wakeUp.addingTimeInterval(minutes: diffMins)
            )
        }
    }

    func testUpdateScheduleEditToBed() {

        // Given

        let schedule = Schedule(
            sleepDuration: 8 * 60,
            intensity: .normal,
            toBed: time(day: 1, hour: 23),
            wakeUp: time(day: 1, hour: 7),
            targetToBed: time(day: 1, hour: 23),
            targetWakeUp: time(day: 1, hour: 7)
        )
        let newToBed = time(day: 1, hour: 22)
        let diffMins = -60

        var newSchedule: Schedule?
        let saveExpectation = expectation(description: "save")
        let deleteExpectation = expectation(description: "delete")
        scheduleRepository.saveHandler = handleSave
        scheduleRepository.deleteAllHandler = handleDeleteAll

        // When

        updateSchedule.callAsFunction(
            current: schedule,
            newSleepDuration: nil,
            newToBed: newToBed
        )

        // Then

        func handleSave(_ schedule: Schedule) {
            newSchedule = schedule
            saveExpectation.fulfill()
        }

        func handleDeleteAll() {
            deleteExpectation.fulfill()
        }

        waitForExpectations(timeout: 1) { error in
            if let error = error {
                XCTFail(error.localizedDescription)
                return
            }

            XCTAssertEqual(newSchedule?.sleepDuration, schedule.sleepDuration)
            XCTAssertEqual(newSchedule?.intensity, schedule.intensity)
            XCTAssertEqual(newSchedule?.targetToBed, newToBed)
            XCTAssertEqual(
                newSchedule?.targetWakeUp,
                schedule.targetWakeUp.addingTimeInterval(minutes: diffMins)
            )
            XCTAssertEqual(newSchedule?.toBed, schedule.toBed)
            XCTAssertEqual(
                newSchedule?.wakeUp,
                schedule.wakeUp
            )
        }
    }

    func testUpdateScheduleEditToBedNeedsNormalisation() {

        // Given

        let schedule = Schedule(
            sleepDuration: 8 * 60,
            intensity: .normal,
            toBed: time(day: 1, hour: 23),
            wakeUp: time(day: 1, hour: 7),
            targetToBed: time(day: 1, hour: 23),
            targetWakeUp: time(day: 1, hour: 7)
        )
        let newToBed = time(day: 3, hour: 22)
        let correctNewToBed = time(day: 1, hour: 22)
        let diffMins = -60

        var newSchedule: Schedule?
        let saveExpectation = expectation(description: "save")
        let deleteExpectation = expectation(description: "delete")
        scheduleRepository.saveHandler = handleSave
        scheduleRepository.deleteAllHandler = handleDeleteAll

        // When

        updateSchedule.callAsFunction(
            current: schedule,
            newSleepDuration: nil,
            newToBed: newToBed
        )

        // Then

        func handleSave(_ schedule: Schedule) {
            newSchedule = schedule
            saveExpectation.fulfill()
        }

        func handleDeleteAll() {
            deleteExpectation.fulfill()
        }

        waitForExpectations(timeout: 1) { error in
            if let error = error {
                XCTFail(error.localizedDescription)
                return
            }

            XCTAssertEqual(newSchedule?.sleepDuration, schedule.sleepDuration)
            XCTAssertEqual(newSchedule?.intensity, schedule.intensity)
            XCTAssertEqual(newSchedule?.targetToBed, correctNewToBed)
            XCTAssertEqual(
                newSchedule?.targetWakeUp,
                schedule.targetWakeUp.addingTimeInterval(minutes: diffMins)
            )
            XCTAssertEqual(newSchedule?.toBed, schedule.toBed)
            XCTAssertEqual(
                newSchedule?.wakeUp,
                schedule.wakeUp
            )
        }
    }

    func testUpdateScheduleEditSleepDurationAndEditToBedNeedsNormalisation() {

        // Given

        let schedule = Schedule(
            sleepDuration: 8 * 60,
            intensity: .normal,
            toBed: time(day: 1, hour: 23),
            wakeUp: time(day: 1, hour: 7),
            targetToBed: time(day: 1, hour: 23),
            targetWakeUp: time(day: 1, hour: 7)
        )
        let newSleepDuration = 7 * 60
        let newToBed = time(day: 3, hour: 22)
        let correctNewToBed = time(day: 1, hour: 22)
        let diffMins = -120

        var newSchedule: Schedule?
        let saveExpectation = expectation(description: "save")
        let deleteExpectation = expectation(description: "delete")
        scheduleRepository.saveHandler = handleSave
        scheduleRepository.deleteAllHandler = handleDeleteAll

        // When

        updateSchedule.callAsFunction(
            current: schedule,
            newSleepDuration: newSleepDuration,
            newToBed: newToBed
        )

        // Then

        func handleSave(_ schedule: Schedule) {
            newSchedule = schedule
            saveExpectation.fulfill()
        }

        func handleDeleteAll() {
            deleteExpectation.fulfill()
        }

        waitForExpectations(timeout: 1) { error in
            if let error = error {
                XCTFail(error.localizedDescription)
                return
            }

            XCTAssertEqual(newSchedule?.sleepDuration, newSleepDuration)
            XCTAssertEqual(newSchedule?.intensity, schedule.intensity)
            XCTAssertEqual(newSchedule?.targetToBed, correctNewToBed)
            XCTAssertEqual(
                newSchedule?.targetWakeUp,
                schedule.targetWakeUp.addingTimeInterval(minutes: diffMins)
            )
            XCTAssertEqual(newSchedule?.toBed, schedule.toBed)
            XCTAssertEqual(
                newSchedule?.wakeUp,
                schedule.wakeUp.addingTimeInterval(minutes: diffMins / 2)
            )
        }
    }

    // MARK: - Get Schedule

    func testGetScheduleNoSchedule() {

        // Given

        scheduleRepository.getLatestHandler = { return nil }
        scheduleRepository.getForDateHandler = { _ in return nil }

        // When

        let yesterdaySchedule = getSchedule.yesterday()
        let todaySchedule = getSchedule.today()
        let tomorrowSchedule = getSchedule.tomorrow()

        // Then

        XCTAssertNil(yesterdaySchedule)
        XCTAssertNil(todaySchedule)
        XCTAssertNil(tomorrowSchedule)
    }

    func testGetScheduleScheduledSinceToday() {

        // Given

        let getSchedule = GetScheduleImpl(scheduleRepository, nextSchedule) {
            self.time(day: 1, hour: 12)
        }

        let schedule = Schedule(
            sleepDuration: 8 * 60,
            intensity: .normal,
            toBed: time(day: 1, hour: 23),
            wakeUp: time(day: 1, hour: 7),
            targetToBed: time(day: 1, hour: 23),
            targetWakeUp: time(day: 1, hour: 7)
        )
        let expectedTomorrowSchedule = Schedule(
            sleepDuration: 8 * 60,
            intensity: .normal,
            toBed: time(day: 2, hour: 23),
            wakeUp: time(day: 2, hour: 7),
            targetToBed: time(day: 2, hour: 23),
            targetWakeUp: time(day: 2, hour: 7)
        )

        var newSchedule: Schedule?
        let saveExpectation = expectation(description: "save")
        scheduleRepository.saveHandler = handleSave
        scheduleRepository.deleteAllHandler = handleDeleteAll
        scheduleRepository.getLatestHandler = { return schedule }
        scheduleRepository.getForDateHandler = { date in
            if calendar.isDate(date, inSameDayAs: schedule.wakeUp) {
                return schedule
            }
            return nil
        }

        // When

        let yesterdaySchedule = getSchedule.yesterday()
        let todaySchedule = getSchedule.today()
        let tomorrowSchedule = getSchedule.tomorrow()

        // Then

        func handleSave(_ schedule: Schedule) {
            newSchedule = schedule
            saveExpectation.fulfill()
        }

        func handleDeleteAll() {
            XCTFail()
        }

        waitForExpectations(timeout: 1) { error in
            if let error = error {
                XCTFail(error.localizedDescription)
                return
            }
            XCTAssertNil(yesterdaySchedule)
            XCTAssertEqual(todaySchedule, schedule)
            XCTAssertEqual(tomorrowSchedule, expectedTomorrowSchedule)
            XCTAssertEqual(newSchedule, expectedTomorrowSchedule)
        }
    }

    func testGetScheduleScheduledSinceTomorrow() {

        // Given

        let getSchedule = GetScheduleImpl(scheduleRepository, nextSchedule) {
            self.time(day: 1, hour: 12)
        }

        let schedule = Schedule(
            sleepDuration: 8 * 60,
            intensity: .normal,
            toBed: time(day: 2, hour: 23),
            wakeUp: time(day: 2, hour: 7),
            targetToBed: time(day: 2, hour: 23),
            targetWakeUp: time(day: 2, hour: 7)
        )

        scheduleRepository.deleteAllHandler = handleDeleteAll
        scheduleRepository.getLatestHandler = {
            return schedule
        }
        scheduleRepository.getForDateHandler = { date in
            if calendar.isDate(date, inSameDayAs: schedule.wakeUp) {
                return schedule
            }
            return nil
        }

        // When

        let yesterdaySchedule = getSchedule.yesterday()
        let todaySchedule = getSchedule.today()
        let tomorrowSchedule = getSchedule.tomorrow()

        // Then

        func handleSave(_ schedule: Schedule) {
            XCTFail()
        }

        func handleDeleteAll() {
            XCTFail()
        }

        XCTAssertNil(yesterdaySchedule)
        XCTAssertNil(todaySchedule)
        XCTAssertEqual(tomorrowSchedule, schedule)
    }

    func testGetScheduleHaveAllDays() {

        // Given

        let getSchedule = GetScheduleImpl(scheduleRepository, nextSchedule) {
            self.time(day: 2, hour: 12)
        }

        let schedules: [Schedule] = [
            Schedule(
                sleepDuration: 8 * 60,
                intensity: .normal,
                toBed: time(day: 1, hour: 23),
                wakeUp: time(day: 1, hour: 7),
                targetToBed: time(day: 1, hour: 23),
                targetWakeUp: time(day: 1, hour: 7)
            ),
            Schedule(
                sleepDuration: 8 * 60,
                intensity: .normal,
                toBed: time(day: 2, hour: 23),
                wakeUp: time(day: 2, hour: 7),
                targetToBed: time(day: 2, hour: 23),
                targetWakeUp: time(day: 2, hour: 7)
            ),
            Schedule(
                sleepDuration: 8 * 60,
                intensity: .normal,
                toBed: time(day: 3, hour: 23),
                wakeUp: time(day: 3, hour: 7),
                targetToBed: time(day: 3, hour: 23),
                targetWakeUp: time(day: 3, hour: 7)
            )
        ]

        scheduleRepository.deleteAllHandler = handleDeleteAll
        scheduleRepository.getLatestHandler = getLatest
        scheduleRepository.getForDateHandler = { date in
            return schedules.first(
                where: { calendar.isDate(date, inSameDayAs: $0.wakeUp) }
            )
        }

        // When

        let yesterdaySchedule = getSchedule.yesterday()
        let todaySchedule = getSchedule.today()
        let tomorrowSchedule = getSchedule.tomorrow()

        // Then

        func handleSave(_ schedule: Schedule) {
            XCTFail()
        }

        func handleDeleteAll() {
            XCTFail()
        }

        func getLatest() -> Schedule? {
            XCTFail()
            return schedules[2]
        }

        XCTAssertEqual(yesterdaySchedule, schedules[0])
        XCTAssertEqual(todaySchedule, schedules[1])
        XCTAssertEqual(tomorrowSchedule, schedules[2])
    }

    func testGetScheduleHaveYesterday() {

        // Given

        let getSchedule = GetScheduleImpl(scheduleRepository, nextSchedule) {
            self.time(day: 2, hour: 12)
        }

        let schedule = Schedule(
            sleepDuration: 8 * 60,
            intensity: .normal,
            toBed: time(day: 1, hour: 23),
            wakeUp: time(day: 1, hour: 7),
            targetToBed: time(day: 1, hour: 23),
            targetWakeUp: time(day: 1, hour: 7)
        )
        let expectedTodaySchedule = Schedule(
            sleepDuration: 8 * 60,
            intensity: .normal,
            toBed: time(day: 2, hour: 23),
            wakeUp: time(day: 2, hour: 7),
            targetToBed: time(day: 2, hour: 23),
            targetWakeUp: time(day: 2, hour: 7)
        )
        let expectedTomorrowSchedule = Schedule(
            sleepDuration: 8 * 60,
            intensity: .normal,
            toBed: time(day: 3, hour: 23),
            wakeUp: time(day: 3, hour: 7),
            targetToBed: time(day: 3, hour: 23),
            targetWakeUp: time(day: 3, hour: 7)
        )

        var savedTodaySchedule: Schedule?
        var savedTomorrowSchedule: Schedule?
        let saveExpectation = expectation(description: "save")
        saveExpectation.expectedFulfillmentCount = 2
        scheduleRepository.deleteAllHandler = handleDeleteAll
        scheduleRepository.saveHandler = handleSave
        scheduleRepository.getLatestHandler = {
            if let savedTodaySchedule = savedTodaySchedule {
                return savedTodaySchedule
            }
            return schedule
        }
        scheduleRepository.getForDateHandler = { date in
            if let savedTodaySchedule = savedTodaySchedule,
               calendar.isDate(date, inSameDayAs: savedTodaySchedule.wakeUp) {
                return savedTodaySchedule
            }
            if calendar.isDate(date, inSameDayAs: schedule.wakeUp) {
                return schedule
            }
            return nil
        }

        // When

        let yesterdaySchedule = getSchedule.yesterday()
        let todaySchedule = getSchedule.today()
        let tomorrowSchedule = getSchedule.tomorrow()

        // Then

        func handleSave(_ schedule: Schedule) {
            if savedTodaySchedule == nil {
                savedTodaySchedule = schedule
            } else {
                savedTomorrowSchedule = schedule
            }
            saveExpectation.fulfill()
        }

        func handleDeleteAll() {
            XCTFail()
        }

        waitForExpectations(timeout: 1) { error in
            if let error = error {
                XCTFail(error.localizedDescription)
                return
            }
            XCTAssertEqual(yesterdaySchedule, schedule)
            XCTAssertEqual(todaySchedule, expectedTodaySchedule)
            XCTAssertEqual(tomorrowSchedule, expectedTomorrowSchedule)
            XCTAssertEqual(savedTodaySchedule, expectedTodaySchedule)
            XCTAssertEqual(savedTomorrowSchedule, expectedTomorrowSchedule)
        }
    }

    func testGetScheduleHave10DaysAgo() {

        // Given

        let getSchedule = GetScheduleImpl(scheduleRepository, nextSchedule) {
            self.time(day: 11, hour: 12)
        }

        let schedule = Schedule(
            sleepDuration: 8 * 60,
            intensity: .normal,
            toBed: time(day: 1, hour: 23),
            wakeUp: time(day: 1, hour: 7),
            targetToBed: time(day: 1, hour: 23),
            targetWakeUp: time(day: 1, hour: 7)
        )
        let expectedYesterdaySchedule = Schedule(
            sleepDuration: 8 * 60,
            intensity: .normal,
            toBed: time(day: 10, hour: 23),
            wakeUp: time(day: 10, hour: 7),
            targetToBed: time(day: 10, hour: 23),
            targetWakeUp: time(day: 10, hour: 7)
        )
        let expectedTodaySchedule = Schedule(
            sleepDuration: 8 * 60,
            intensity: .normal,
            toBed: time(day: 11, hour: 23),
            wakeUp: time(day: 11, hour: 7),
            targetToBed: time(day: 11, hour: 23),
            targetWakeUp: time(day: 11, hour: 7)
        )
        let expectedTomorrowSchedule = Schedule(
            sleepDuration: 8 * 60,
            intensity: .normal,
            toBed: time(day: 12, hour: 23),
            wakeUp: time(day: 12, hour: 7),
            targetToBed: time(day: 12, hour: 23),
            targetWakeUp: time(day: 12, hour: 7)
        )

        var savedSchedules: [Schedule] = [schedule]
        let saveExpectation = expectation(description: "save")
        saveExpectation.expectedFulfillmentCount = 11
        scheduleRepository.deleteAllHandler = handleDeleteAll
        scheduleRepository.saveHandler = handleSave
        scheduleRepository.getLatestHandler = {
            savedSchedules.last
        }
        scheduleRepository.getForDateHandler = { date in
            savedSchedules.first(
                where: { calendar.isDate(date, inSameDayAs: $0.wakeUp) }
            )
        }

        // When

        let yesterdaySchedule = getSchedule.yesterday()
        let todaySchedule = getSchedule.today()
        let tomorrowSchedule = getSchedule.tomorrow()

        // Then

        func handleSave(_ schedule: Schedule) {
            savedSchedules.append(schedule)
            saveExpectation.fulfill()
        }

        func handleDeleteAll() {
            XCTFail()
        }

        waitForExpectations(timeout: 1) { error in
            if let error = error {
                XCTFail(error.localizedDescription)
                return
            }
            XCTAssertEqual(yesterdaySchedule, expectedYesterdaySchedule)
            XCTAssertEqual(todaySchedule, expectedTodaySchedule)
            XCTAssertEqual(tomorrowSchedule, expectedTomorrowSchedule)
            XCTAssertEqual(savedSchedules.count, 12)
            XCTAssertEqual(savedSchedules[11], expectedTomorrowSchedule)
            XCTAssertEqual(savedSchedules[10], expectedTodaySchedule)
            XCTAssertEqual(savedSchedules[9], expectedYesterdaySchedule)
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
        calendar.date(
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

extension ScheduleTests {
    class ScheduleRepositoryMock: ScheduleRepository {
        var saveHandler: ((Schedule) -> Void)?
        var deleteAllHandler: (() -> Void)?
        var getForDateHandler: ((Date) -> Schedule?)?
        var getLatestHandler: (() -> Schedule?)?

        func get(for date: Date) -> Schedule? {
            getForDateHandler?(date)
        }

        func getLatest() -> Schedule? {
            getLatestHandler?()
        }

        func save(_ schedule: Schedule) {
            saveHandler?(schedule)
        }

        func deleteAll() {
            deleteAllHandler?()
        }
    }
}
