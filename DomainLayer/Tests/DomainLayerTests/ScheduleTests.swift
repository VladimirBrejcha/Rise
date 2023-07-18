import XCTest
@testable import DomainLayer
import DataLayer
import Core

class ScheduleTests: XCTestCase {

    var userDataMock = UserDataMock()
    var scheduleRepository = ScheduleRepositoryMock()

    var createSchedule: CreateSchedule { CreateScheduleImpl() }
    var nextSchedule: CreateNextSchedule { CreateNextScheduleImpl(DefaultUserData()) }
    var updateSchedule: UpdateSchedule {
        UpdateScheduleImpl(createSchedule, scheduleRepository)
    }
    var getSchedule: GetSchedule {
        GetScheduleImpl(scheduleRepository, nextSchedule)
    }
    var adjustSchedule: AdjustSchedule {
        AdjustScheduleImpl(scheduleRepository, userDataMock)
    }

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

                    let diff: Int = -(currentHour - wantedHour) * 60
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

        let currentHours = Array(1...7)
        let wantedHours = Array(0...6)

        for duration in allDurations {

            for i in currentHours.indices {

                let currentHour = currentHours[i]

                for wantedHour in wantedHours[0...i] {

                    let intensity: Schedule.Intensity = allIntensities.randomElement()!
                    let currentToBed = time(day: 1, hour: currentHour)
                    let wantedTobed = time(day: 1, hour: wantedHour)

                    let diff: Int = (currentHour - wantedHour) * 60
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

        let currentHours = Array(0...7)
        let wantedHours = Array(0...7)

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

    func testNextSchedule(schedule: Schedule, shift: Int) {

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

        scheduleRepository.saveHandler = handleSave
        scheduleRepository.deleteAllHandler = handleDeleteAll

        // When

        updateSchedule.callAsFunction(
            current: schedule,
            newSleepDuration: nil,
            newToBed: nil,
            newIntensity: nil
        )

        // Then

        func handleSave(_ schedule: Schedule) {
            XCTFail()
        }

        func handleDeleteAll() {
            XCTFail()
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
            newToBed: nil,
            newIntensity: nil
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
            newToBed: newToBed,
            newIntensity: nil
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
            newToBed: newToBed,
            newIntensity: nil
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
            newToBed: newToBed,
            newIntensity: nil
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
        let forNDays = getSchedule.forNextDays(
            numberOfDays: 5, startToday: true
        )

        // Then

        XCTAssertNil(yesterdaySchedule)
        XCTAssertNil(todaySchedule)
        XCTAssertNil(tomorrowSchedule)
        XCTAssertTrue(forNDays.isEmpty)
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
        scheduleRepository.getLatestHandler = { return newSchedule ?? schedule }
        scheduleRepository.getForDateHandler = { date in
            if let newSchedule,
               calendar.isDate(date, inSameDayAs: newSchedule.wakeUp) {
                return newSchedule
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
        let forNDays = getSchedule.forNextDays(
            numberOfDays: 1, startToday: true
        )
        let forNDaysWithoutToday = getSchedule.forNextDays(
            numberOfDays: 1, startToday: false
        )

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
            XCTAssertEqual(forNDays.count, 1)
            XCTAssertEqual(forNDays[0], schedule)
            XCTAssertEqual(forNDaysWithoutToday.count, 1)
            XCTAssertEqual(forNDaysWithoutToday[0], expectedTomorrowSchedule)
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
        let forNDays = getSchedule.forNextDays(
            numberOfDays: 1, startToday: true
        )
        let forNDaysWithoutToday = getSchedule.forNextDays(
            numberOfDays: 1, startToday: false
        )

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
        XCTAssertEqual(forNDays.count, 0)
        XCTAssertEqual(forNDaysWithoutToday.count, 1)
        XCTAssertEqual(forNDaysWithoutToday[0], tomorrowSchedule)
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
        let forNDays = getSchedule.forNextDays(
            numberOfDays: 1, startToday: true
        )
        let forNDaysWithoutToday = getSchedule.forNextDays(
            numberOfDays: 1, startToday: false
        )

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
        XCTAssertEqual(forNDays.count, 1)
        XCTAssertEqual(forNDays[0], schedules[1])
        XCTAssertEqual(forNDaysWithoutToday.count, 1)
        XCTAssertEqual(forNDaysWithoutToday[0], schedules[2])
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

    func testGetScheduleHaveNext10Days() {

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

        let expectedSchedules: [Schedule] = [
            Schedule(
                sleepDuration: 8 * 60,
                intensity: .normal,
                toBed: time(day: 1, hour: 23),
                wakeUp: time(day: 1, hour: 7),
                targetToBed: time(day: 1, hour: 23),
                targetWakeUp: time(day: 1, hour: 7)
            ), // today
            Schedule(
                sleepDuration: 8 * 60,
                intensity: .normal,
                toBed: time(day: 2, hour: 23),
                wakeUp: time(day: 2, hour: 7),
                targetToBed: time(day: 2, hour: 23),
                targetWakeUp: time(day: 2, hour: 7)
            ), // tomorrow
            Schedule(
                sleepDuration: 8 * 60,
                intensity: .normal,
                toBed: time(day: 3, hour: 23),
                wakeUp: time(day: 3, hour: 7),
                targetToBed: time(day: 3, hour: 23),
                targetWakeUp: time(day: 3, hour: 7)
            ), // 2
            Schedule(
                sleepDuration: 8 * 60,
                intensity: .normal,
                toBed: time(day: 4, hour: 23),
                wakeUp: time(day: 4, hour: 7),
                targetToBed: time(day: 4, hour: 23),
                targetWakeUp: time(day: 4, hour: 7)
            ), // 3
            Schedule(
                sleepDuration: 8 * 60,
                intensity: .normal,
                toBed: time(day: 5, hour: 23),
                wakeUp: time(day: 5, hour: 7),
                targetToBed: time(day: 5, hour: 23),
                targetWakeUp: time(day: 5, hour: 7)
            ), // 4
            Schedule(
                sleepDuration: 8 * 60,
                intensity: .normal,
                toBed: time(day: 6, hour: 23),
                wakeUp: time(day: 6, hour: 7),
                targetToBed: time(day: 6, hour: 23),
                targetWakeUp: time(day: 6, hour: 7)
            ), // 5
            Schedule(
                sleepDuration: 8 * 60,
                intensity: .normal,
                toBed: time(day: 7, hour: 23),
                wakeUp: time(day: 7, hour: 7),
                targetToBed: time(day: 7, hour: 23),
                targetWakeUp: time(day: 7, hour: 7)
            ), // 6
            Schedule(
                sleepDuration: 8 * 60,
                intensity: .normal,
                toBed: time(day: 8, hour: 23),
                wakeUp: time(day: 8, hour: 7),
                targetToBed: time(day: 8, hour: 23),
                targetWakeUp: time(day: 8, hour: 7)
            ), // 7
            Schedule(
                sleepDuration: 8 * 60,
                intensity: .normal,
                toBed: time(day: 9, hour: 23),
                wakeUp: time(day: 9, hour: 7),
                targetToBed: time(day: 9, hour: 23),
                targetWakeUp: time(day: 9, hour: 7)
            ), // 8
            Schedule(
                sleepDuration: 8 * 60,
                intensity: .normal,
                toBed: time(day: 10, hour: 23),
                wakeUp: time(day: 10, hour: 7),
                targetToBed: time(day: 10, hour: 23),
                targetWakeUp: time(day: 10, hour: 7)
            ), // 9
            Schedule(
                sleepDuration: 8 * 60,
                intensity: .normal,
                toBed: time(day: 11, hour: 23),
                wakeUp: time(day: 11, hour: 7),
                targetToBed: time(day: 11, hour: 23),
                targetWakeUp: time(day: 11, hour: 7)
            ), // 10
        ]

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

        let todaySchedule = getSchedule.today()
        let tomorrowSchedule = getSchedule.tomorrow()
        let forNDays = getSchedule.forNextDays(
            numberOfDays: 11, startToday: true
        )
        let forNDaysWithoutToday = getSchedule.forNextDays(
            numberOfDays: 11, startToday: false
        )

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
            XCTAssertEqual(todaySchedule, expectedSchedules[0])
            XCTAssertEqual(tomorrowSchedule, expectedSchedules[1])
            XCTAssertEqual(savedSchedules.count, 12)
            XCTAssertEqual(forNDays.count, 11)
            for day in (0...10) {
                let expected = savedSchedules[day]
                let got = forNDays[day]
                XCTAssertEqual(expected, got)
            }
            XCTAssertEqual(forNDaysWithoutToday.count, 11)
            for day in (0...10) {
                let expected = savedSchedules[day + 1]
                let got = forNDaysWithoutToday[day]
                XCTAssertEqual(expected, got)
            }
        }
    }

    // MARK: - AdjustSchedule

    func testAdjustScheduleNoEdit() {

        // Given

        let schedule = Schedule(
            sleepDuration: 8 * 60,
            intensity: .normal,
            toBed: time(day: 1, hour: 23),
            wakeUp: time(day: 1, hour: 7),
            targetToBed: time(day: 1, hour: 23),
            targetWakeUp: time(day: 1, hour: 7)
        )

        scheduleRepository.saveHandler = handleSave
        scheduleRepository.deleteAllHandler = handleDeleteAll

        // When

        adjustSchedule.callAsFunction(
            currentSchedule: schedule,
            newToBed: time(day: 1, hour: 23)
        )

        // Then

        func handleSave(_ schedule: Schedule) {
            XCTFail()
        }

        func handleDeleteAll() {
            XCTFail()
        }
    }

    func testAdjustScheduleEdit() {

        // Given

        let schedule = Schedule(
            sleepDuration: 8 * 60,
            intensity: .normal,
            toBed: time(day: 1, hour: 23),
            wakeUp: time(day: 1, hour: 7),
            targetToBed: time(day: 1, hour: 23),
            targetWakeUp: time(day: 1, hour: 7)
        )

        let newToBedDates = [
            time(day: 2, hour: 0),
            time(day: 1, hour: 22),
            time(day: 0, hour: 23, min: 1),
            time(day: 2, hour: 22, min: 59),
            time(day: 1, hour: 5)
        ]
        var newSchedules: [Schedule] = []

        let saveExpectation = expectation(description: "save")
        saveExpectation.expectedFulfillmentCount = newToBedDates.count

        let deleteExpectation = expectation(description: "delete")
        deleteExpectation.expectedFulfillmentCount = newToBedDates.count

        scheduleRepository.saveHandler = handleSave
        scheduleRepository.deleteAllHandler = handleDeleteAll

        // When

        newToBedDates.forEach { newToBed in
            adjustSchedule.callAsFunction(
                currentSchedule: schedule,
                newToBed: newToBed
            )
        }

        // Then

        let expectedSchedules = newToBedDates.map { newToBed in
            Schedule(
                sleepDuration: 8 * 60,
                intensity: .normal,
                toBed: newToBed,
                wakeUp: time(day: 1, hour: 7),
                targetToBed: time(day: 1, hour: 23),
                targetWakeUp: time(day: 1, hour: 7)
            )
        }

        func handleSave(_ schedule: Schedule) {
            newSchedules.append(schedule)
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
            XCTAssertEqual(expectedSchedules, newSchedules)
            newSchedules.forEach {
                XCTAssertNotEqual($0, schedule)
            }
        }
    }

    func testAdjustScheduleEditDateFarAway() {

        // Given

        let schedule = Schedule(
            sleepDuration: 8 * 60,
            intensity: .normal,
            toBed: time(day: 1, hour: 23),
            wakeUp: time(day: 1, hour: 7),
            targetToBed: time(day: 1, hour: 23),
            targetWakeUp: time(day: 1, hour: 7)
        )

        let newToBedDates = [
            time(day: 3, hour: 0),
            time(day: 0, hour: 22, min: 59),
            time(day: 20, hour: 23, min: 1),
            time(month: 10, day: 1, hour: 22)
        ]
        let expectedToBedDates = [
            time(day: 2, hour: 0),
            time(day: 1, hour: 22, min: 59),
            time(day: 1, hour: 23, min: 1),
            time(month: 1, day: 2, hour: 22)
        ]
        var newSchedules: [Schedule] = []

        let saveExpectation = expectation(description: "save")
        saveExpectation.expectedFulfillmentCount = expectedToBedDates.count

        let deleteExpectation = expectation(description: "delete")
        deleteExpectation.expectedFulfillmentCount = expectedToBedDates.count

        scheduleRepository.saveHandler = handleSave
        scheduleRepository.deleteAllHandler = handleDeleteAll

        // When

        newToBedDates.forEach { newToBed in
            adjustSchedule.callAsFunction(
                currentSchedule: schedule,
                newToBed: newToBed
            )
        }

        // Then

        let expectedSchedules = expectedToBedDates.map { newToBed in
            Schedule(
                sleepDuration: 8 * 60,
                intensity: .normal,
                toBed: newToBed,
                wakeUp: time(day: 1, hour: 7),
                targetToBed: time(day: 1, hour: 23),
                targetWakeUp: time(day: 1, hour: 7)
            )
        }

        func handleSave(_ schedule: Schedule) {
            newSchedules.append(schedule)
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
            expectedSchedules.enumerated().forEach {
                let expected = $0.element
                let actual = newSchedules[$0.offset]
                XCTAssertEqual(actual, expected, "\n\n\(expected.toBed)\n!=\n\(actual.toBed)\n")
            }
            newSchedules.forEach {
                XCTAssertNotEqual($0, schedule)
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

import Combine

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

        func publisher() -> AnyPublisher<([(LocalDataSourceObjectChange, Core.Schedule)]), Never> {
            Just([]).eraseToAnyPublisher()
        }
    }
}

extension ScheduleTests {
    class UserDataMock: UserData {
        var preferredWakeUpTime: Date? = nil
        var keepAppOpenedSuggested: Bool = false
        var activeSleepStartDate: Date? = nil
        var activeSleepEndDate: Date? = nil
        var onboardingCompleted: Bool = true
        var scheduleOnPause: Bool = false
        var latestAppUsageDate: Date? = nil
        func invalidateActiveSleep() { }
    }
}
