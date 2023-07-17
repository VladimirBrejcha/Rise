import XCTest
@testable import DataLayer
import Core
import CoreLocation

class SunTimeRepositoryTests: XCTestCase {

    // MARK: - Mocks

    class SunTimeCoreDataServiceFakeDataImpl: SunTimeLocalDataSource {
        private let fakeData: [SunTime]

        init(fakeData: [SunTime]) {
            self.fakeData = fakeData
        }

        func getSunTimes(for dates: [Date]) throws -> [SunTime] {
            fakeData
        }

        func save(sunTimes: [SunTime]) throws { }

        func deleteAll() throws { }
    }

    class SunTimeAPIServiceFakeDataImpl: WeatherService {
        private let fakeData: [SunTime]

        init(fakeData: [SunTime]) {
            self.fakeData = fakeData
        }
        
        func requestSunTimes(
            for dateInterval: DateInterval,
            location: CLLocation
        ) async throws -> [SunTime] {
            return fakeData
        }
    }

    // MARK: - Tests

    func testLocalOnly() {
        setUp()

        let repository = SunTimeRepositoryImpl(
            SunTimeCoreDataServiceFakeDataImpl(fakeData: fakeSunTimes),
            SunTimeAPIServiceFakeDataImpl(fakeData: [])
        )

        repository.requestSunTimes(
            dates: fakeRequestedDates,
            location: CLLocation()
        ) { result in
            if case let .success(sunTimes) = result {
                XCTAssertEqual(sunTimes.count, self.fakeRequestedDates.count)
            } else {
                XCTAssert(false)
            }
        }
    }

    func testRemoteOnly() {
        setUp()

        let repository = SunTimeRepositoryImpl(
            SunTimeCoreDataServiceFakeDataImpl(fakeData: []),
            SunTimeAPIServiceFakeDataImpl(fakeData: fakeSunTimes)
        )

        repository.requestSunTimes(
            dates: fakeRequestedDates,
            location: CLLocation()
        ) { result in
            if case let .success(sunTimes) = result {
                XCTAssertEqual(sunTimes.count, self.fakeRequestedDates.count)
            } else {
                XCTAssert(false)
            }
        }
    }

    func testLocalAndRemote() {
        setUp()

        let repository = SunTimeRepositoryImpl(
            SunTimeCoreDataServiceFakeDataImpl(fakeData: [fakeSunTimes[0]]),
            SunTimeAPIServiceFakeDataImpl(fakeData: Array(fakeSunTimes[1...2]))
        )

        repository.requestSunTimes(
            dates: fakeRequestedDates,
            location: CLLocation()
        ) { result in
            if case let .success(sunTimes) = result {
                XCTAssertEqual(sunTimes.count, self.fakeRequestedDates.count)
            } else {
                XCTAssert(false)
            }
        }
    }

    func testSaving() {
        class SunTimeCoreDataServiceFakeDataSaverImpl: SunTimeLocalDataSource {
            private let fakeData: [SunTime]
            var savedData: [SunTime] = []

            init(fakeData: [SunTime]) {
                self.fakeData = fakeData
            }

            func getSunTimes(for dates: [Date]) throws -> [SunTime] {
                fakeData
            }

            func save(sunTimes: [SunTime]) throws {
                savedData.append(contentsOf: sunTimes)
            }

            func deleteAll() throws { }
        }

        setUp()

        let localDataSource = SunTimeCoreDataServiceFakeDataSaverImpl(fakeData: [fakeSunTimes[0]])

        let repository = SunTimeRepositoryImpl(
            localDataSource,
            SunTimeAPIServiceFakeDataImpl(fakeData: Array(fakeSunTimes[1...2]))
        )

        repository.requestSunTimes(
            dates: fakeRequestedDates,
            location: CLLocation()
        ) { result in
            if case .success = result {
                XCTAssertEqual(localDataSource.savedData, Array(self.fakeSunTimes[1...2]))
            } else {
                XCTAssert(false)
            }
        }
    }

    func testDeleting() {
        class SunTimeCoreDataServiceDataDeleter: SunTimeLocalDataSource {

            let expectation: XCTestExpectation

            init(expectation: XCTestExpectation) {
                self.expectation = expectation
            }

            func getSunTimes(for dates: [Date]) throws -> [SunTime] { [] }

            func save(sunTimes: [SunTime]) throws { }

            func deleteAll() throws {
                expectation.fulfill()
            }
        }

        setUp()

        let expectation = expectation(description: "fail")

        let repository = SunTimeRepositoryImpl(
            SunTimeCoreDataServiceDataDeleter(expectation: expectation),
            SunTimeAPIServiceFakeDataImpl(fakeData: [])
        )

        repository.deleteAll()

        wait(for: [expectation], timeout: 1)
    }

    func testFail() {
        class SunTimeCoreDataServiceFailingImpl: SunTimeLocalDataSource {
            func getSunTimes(for dates: [Date]) throws -> [SunTime] {
                throw NetworkError.internalError
            }

            func save(sunTimes: [SunTime]) throws { }

            func deleteAll() throws { }
        }

        class SunTimeAPIServiceFailingImpl: WeatherService {
            func requestSunTimes(for dateInterval: DateInterval, location: CLLocation) async throws -> [SunTime] {
                throw NetworkError.internalError
            }
        }

        setUp()

        let repository = SunTimeRepositoryImpl(
            SunTimeCoreDataServiceFailingImpl(),
            SunTimeAPIServiceFailingImpl()
        )

        repository.requestSunTimes(
            dates: fakeRequestedDates,
            location: CLLocation()
        ) { result in
            if case .success = result {
                XCTAssert(false)
            } else {
                XCTAssert(true)
            }
        }
    }

    // MARK: - Fake data

    let fakeRequestedDates: [Date] = [
        Date().noon,
        Date().addingTimeInterval(days: 1).noon,
        Date().addingTimeInterval(days: 2).noon
    ]

    let fakeSunTimes: [SunTime] = [
        .init(sunrise: Date().noon, sunset: Date().noon),
        .init(sunrise: Date().addingTimeInterval(days: 1).noon, sunset: Date().addingTimeInterval(days: 1).noon),
        .init(sunrise: Date().addingTimeInterval(days: 2).noon, sunset: Date().addingTimeInterval(days: 2).noon)
    ]
}
