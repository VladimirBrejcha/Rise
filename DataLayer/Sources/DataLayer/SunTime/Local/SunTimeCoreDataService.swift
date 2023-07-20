import CoreData
import Core

final class SunTimeCoreDataService:
    LocalDataSource<RiseSunTime>,
    SunTimeLocalDataSource
{
    func getSunTimes(for dates: [Date]) throws -> [SunTime] {
        log(.info, "dates = \(dates)")

        return try dates.compactMap { date in
            try container
                .fetch(requestBuilder: {
                    $0.predicate = date.dayPredicate
                })
                .first
                .flatMap(buildModel(from:))
        }
    }

    func delete(before date: Date) throws {
        log(.info, "date: \(date)")

        try container.fetch(requestBuilder: {
          $0.predicate = date.beforePredicate
        }).forEach {
          context.delete($0)
        }
        try container.saveContext()
    }

    func save(sunTimes: [SunTime]) throws {
        log(.info, "sunTimes: \(sunTimes)")

        try sunTimes.forEach { sunTime in
            let sunTimeObject = insertObject()
            update(object: sunTimeObject, with: sunTime)
            try container.saveContext()
        }
    }

    // MARK: Private -

    private func buildModel(from object: RiseSunTime) -> SunTime {
        return SunTime(sunrise: object.sunrise, sunset: object.sunset)
    }

    private func update(object: RiseSunTime, with model: SunTime) {
        object.sunrise = model.sunrise
        object.sunset = model.sunset
    }
}

fileprivate extension Date {

    var beforePredicate: NSPredicate {
        return NSPredicate(
            format: "sunrise =< %@",
            argumentArray: [self]
        )
    }

    var dayPredicate: NSPredicate {

        var components = calendar.dateComponents(
            [.year, .month, .day, .hour, .minute, .second],
            from: self
        )

        components.hour = 00
        components.minute = 00
        components.second = 00
        let startDate = calendar.date(from: components)
        assert(startDate != nil)

        components.hour = 23
        components.minute = 59
        components.second = 59
        let endDate = calendar.date(from: components)
        assert(endDate != nil)

        return NSPredicate(
            format: "sunrise >= %@ AND sunrise =< %@",
            argumentArray: [startDate ?? Date(), endDate ?? Date()]
        )
    }
}
