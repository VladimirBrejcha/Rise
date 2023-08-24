import XCTest
@testable import DataLayer
import Core
import CoreLocation

class SunTimeRepositoryTests: XCTestCase {

    // MARK: - Mocks

    class SunTimeCoreDataServiceFakeDataImpl: SunTimeLocalDataSource {
        func delete(before date: Date) throws { }

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
        func getAttribution() async throws -> WKLegal {
            .init(img: Data(), url: URL(filePath: "/"))
        }

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

    func testLocalOnly() async throws {
        try await setUp()

        let repository = SunTimeRepositoryImpl(
            SunTimeCoreDataServiceFakeDataImpl(fakeData: fakeSunTimes),
            SunTimeAPIServiceFakeDataImpl(fakeData: [])
        )

        let result = await repository.requestSunTimes(
            dates: fakeRequestedDates,
            location: CLLocation()
        )
        if case let .success(sunTimes) = result {
            XCTAssertEqual(sunTimes.0.count, fakeRequestedDates.count)
        } else {
            XCTAssert(false)
        }
    }

    func testRemoteOnly() async throws {
        try await setUp()

        let repository = SunTimeRepositoryImpl(
            SunTimeCoreDataServiceFakeDataImpl(fakeData: []),
            SunTimeAPIServiceFakeDataImpl(fakeData: fakeSunTimes)
        )

        let result = await repository.requestSunTimes(
            dates: fakeRequestedDates,
            location: CLLocation()
        )
        if case let .success(sunTimes) = result {
            XCTAssertEqual(sunTimes.0.count, fakeRequestedDates.count)
        } else {
            XCTAssert(false)
        }
    }

    func testLocalAndRemote() async throws {
        try await setUp()

        let repository = SunTimeRepositoryImpl(
            SunTimeCoreDataServiceFakeDataImpl(fakeData: [fakeSunTimes[0]]),
            SunTimeAPIServiceFakeDataImpl(fakeData: Array(fakeSunTimes[1...2]))
        )

        let result = await repository.requestSunTimes(
            dates: fakeRequestedDates,
            location: CLLocation()
        )
        if case let .success(sunTimes) = result {
            XCTAssertEqual(sunTimes.0.count, fakeRequestedDates.count)
        } else {
            XCTAssert(false)
        }
    }

    func testSaving() async throws {
        class SunTimeCoreDataServiceFakeDataSaverImpl: SunTimeLocalDataSource {
            func delete(before date: Date) throws { }

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

        try await setUp()

        let localDataSource = SunTimeCoreDataServiceFakeDataSaverImpl(fakeData: [fakeSunTimes[0]])

        let repository = SunTimeRepositoryImpl(
            localDataSource,
            SunTimeAPIServiceFakeDataImpl(fakeData: Array(fakeSunTimes[1...2]))
        )

        let result = await repository.requestSunTimes(
            dates: fakeRequestedDates,
            location: CLLocation()
        )
        if case .success = result {
            XCTAssertEqual(localDataSource.savedData, Array(fakeSunTimes[1...2]))
        } else {
            XCTAssert(false)
        }
    }

    func testDeleting() {
        class SunTimeCoreDataServiceDataDeleter: SunTimeLocalDataSource {
            func delete(before date: Date) throws {}


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

    func testFail() async throws {
        class SunTimeCoreDataServiceFailingImpl: SunTimeLocalDataSource {
            func delete(before date: Date) throws { }

            func getSunTimes(for dates: [Date]) throws -> [SunTime] {
                throw NetworkError.internalError
            }

            func save(sunTimes: [SunTime]) throws { }

            func deleteAll() throws { }
        }

        class SunTimeAPIServiceFailingImpl: WeatherService {
            func getAttribution() async throws -> WKLegal {
                WKLegal(img: Data(), url: URL(filePath: "/"))
            }

            func requestSunTimes(for dateInterval: DateInterval, location: CLLocation) async throws -> [SunTime] {
                throw NetworkError.internalError
            }
        }

        try await setUp()

        let repository = SunTimeRepositoryImpl(
            SunTimeCoreDataServiceFailingImpl(),
            SunTimeAPIServiceFailingImpl()
        )

        let result = await repository.requestSunTimes(
            dates: fakeRequestedDates,
            location: CLLocation()
        )
        if case .success = result {
            XCTAssert(false)
        } else {
            XCTAssert(true)
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
