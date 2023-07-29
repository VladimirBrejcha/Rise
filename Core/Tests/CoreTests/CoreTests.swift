import XCTest
@testable import Core
import Foundation

class DateUtilsTests: XCTestCase {

    func testWithin24h() {

        // given

        let now = Date.now

        let testDates = [
            now,
            now.addingTimeInterval(days: 1)
                .addingTimeInterval(minutes: 1),
            now.addingTimeInterval(days: -1),
            now.addingTimeInterval(days: 0),
            now.addingTimeInterval(minutes: 300),
            now.addingTimeInterval(days: 50),
            now.addingTimeInterval(days: -50),
            now.addingTimeInterval(minutes: 23 * 60 + 59),
            now.addingTimeInterval(minutes: -23 * 60 - 59),
            now.addingTimeInterval(minutes: -1),
            now.addingTimeInterval(days: -1)
                .addingTimeInterval(minutes: -1),
        ]

        let expected = [
            now,
            now.addingTimeInterval(minutes: 1),
            now,
            now,
            now.addingTimeInterval(minutes: 300),
            now,
            now,
            now.addingTimeInterval(minutes: 23 * 60 + 59),
            now.addingTimeInterval(minutes: 1),
            now.addingTimeInterval(days: 1)
                .addingTimeInterval(minutes: -1),
            now.addingTimeInterval(days: 1)
                .addingTimeInterval(minutes: -1),
        ]

        // when

        let results = testDates.map { $0.withinNext24h(of: now) }

        // then

        XCTAssertEqual(testDates.count, expected.count)
        XCTAssertEqual(expected.count, results.count)
        
        zip(results, expected).forEach { (res, exp) in
            XCTAssertEqual(res, exp, "now \(now)")
        }
    }

    // MARK: - Utils -

    private func time(
        fromNow now: Date,
        addDays: Int = 0,
        addHour hour: Int = 0,
        addMin min: Int = 0
    ) -> Date {
        let components = calendar
            .dateComponents(
                [.year, .month, .day, .hour, .minute, .second],
                from: now
            )
        return calendar.date(
            from: .init(
                year: components.year!,
                month: components.month!,
                day: components.day! + addDays,
                hour: components.hour! + hour,
                minute: components.minute! + min,
                second: components.second!
            )
        )!
    }
}
