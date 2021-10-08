//
//  SunTimeRepositoryTests.swift
//  RiseTests
//
//  Created by Vladimir Korolev on 20.09.2021.
//  Copyright © 2021 VladimirBrejcha. All rights reserved.
//

import XCTest
@testable import Rise

class SunTimeRepositoryTests: XCTestCase {

    // MARK: - Mocks

    class SunTimeCoreDataServiceFakeDataImpl: SunTimeCoreDataService {
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

    class SunTimeAPIServiceFakeDataImpl: SunTimeAPIService {
        private let fakeData: [SunTime]

        init(fakeData: [SunTime]) {
            self.fakeData = fakeData
        }

        func requestSunTimes(
            for dates: [Date],
            location: Location,
            completion: @escaping (SunTimeAPIServiceResult) -> Void
        ) {
            completion(.success(fakeData))
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
            location: .init(latitude: "", longitude: "")
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
            location: .init(latitude: "", longitude: "")
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
            location: .init(latitude: "", longitude: "")
        ) { result in
            if case let .success(sunTimes) = result {
                XCTAssertEqual(sunTimes.count, self.fakeRequestedDates.count)
            } else {
                XCTAssert(false)
            }
        }
    }

    func testSaving() {
        class SunTimeCoreDataServiceFakeDataSaverImpl: SunTimeCoreDataService {
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
            location: .init(latitude: "", longitude: "")
        ) { result in
            if case .success = result {
                XCTAssertEqual(localDataSource.savedData, Array(self.fakeSunTimes[1...2]))
            } else {
                XCTAssert(false)
            }
        }
    }

    func testDeleting() {
        class SunTimeCoreDataServiceDataDeleter: SunTimeCoreDataService {

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

        try! repository.deleteAll()

        wait(for: [expectation], timeout: 1)
    }

    func testFail() {
        class SunTimeCoreDataServiceFailingImpl: SunTimeCoreDataService {
            func getSunTimes(for dates: [Date]) throws -> [SunTime] {
                throw NetworkError.internalError
            }

            func save(sunTimes: [SunTime]) throws { }

            func deleteAll() throws { }
        }

        class SunTimeAPIServiceFailingImpl: SunTimeAPIService {
            func requestSunTimes(
                for dates: [Date],
                location: Location,
                completion: @escaping (SunTimeAPIServiceResult) -> Void
            ) {
                completion(.failure(NetworkError.internalError))
            }
        }

        setUp()

        let repository = SunTimeRepositoryImpl(
            SunTimeCoreDataServiceFailingImpl(),
            SunTimeAPIServiceFailingImpl()
        )

        repository.requestSunTimes(
            dates: fakeRequestedDates,
            location: .init(latitude: "", longitude: "")
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
        Date().appending(days: 1).noon,
        Date().appending(days: 2).noon
    ]

    let fakeSunTimes: [SunTime] = [
        .init(sunrise: Date().noon, sunset: Date().noon),
        .init(sunrise: Date().appending(days: 1).noon, sunset: Date().appending(days: 1).noon),
        .init(sunrise: Date().appending(days: 2).noon, sunset: Date().appending(days: 2).noon)
    ]
}