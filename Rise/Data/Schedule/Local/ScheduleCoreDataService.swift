//
//  ScheduleCoreDataService.swift
//  Rise
//
//  Created by Vladimir Korolev on 06.11.2021.
//  Copyright © 2021 VladimirBrejcha. All rights reserved.
//

import Foundation

final class ScheduleCoreDataService:
    LocalDataSource<ScheduleObject>,
    ScheduleLocalDataSource
{
    func get(for date: Date) throws -> Schedule {
        log(.info, "date: \(date)")

        let fetchResult = try container.fetch(requestBuilder: {
            $0.predicate = date.dayPredicate
        })
        if fetchResult.isEmpty {
            throw ScheduleLocalDataSourceError.noScheduleForTheDate
        }
        if let schedule = Schedule.init(object: fetchResult[0]) {
            return schedule
        } else {
            throw ScheduleLocalDataSourceError.failedToRecreateSchedule
        }
    }

    func getLatest() throws -> Schedule {
        log(.info)

        let fetchResult = try container.fetch(requestBuilder: {
            $0.sortDescriptors = [NSSortDescriptor(key: "wakeUp", ascending: false)]
            $0.fetchLimit = 1
        })
        if fetchResult.isEmpty {
            throw ScheduleLocalDataSourceError.noScheduleForTheDate
        }
        if let schedule = Schedule.init(object: fetchResult[0]) {
            return schedule
        } else {
            throw ScheduleLocalDataSourceError.failedToRecreateSchedule
        }
    }

    func save(_ schedule: Schedule) throws {
        log(.info, "schedule: \(schedule)")

        let scheduleObject = insertObject()
        scheduleObject.update(with: schedule)
        try container.saveContext()
    }

    func delete(for date: Date) throws {
        log(.info, "date: \(date)")

        try container.fetch(requestBuilder: {
            $0.predicate = date.dayPredicate
        }).forEach {
            context.delete($0)
        }
        try container.saveContext()
    }

    func deleteLatest() throws {
        log(.info)

        try container.fetch(requestBuilder: {
            $0.sortDescriptors = [NSSortDescriptor(key: "wakeUp", ascending: false)]
            $0.fetchLimit = 1
        }).forEach {
            context.delete($0)
        }
        try container.saveContext()
    }
}

fileprivate extension ScheduleObject {
    func update(with schedule: Schedule) {
        sleepDuration = Int16(schedule.sleepDuration)
        intensity = schedule.intensity.rawValue
        toBed = schedule.toBed
        wakeUp = schedule.wakeUp
        targetToBed = schedule.targetToBed
        targetWakeUp = schedule.targetWakeUp
    }
}

fileprivate extension Schedule {
    init?(object: ScheduleObject) {
        guard let intensity = Schedule.Intensity.init(rawValue: object.intensity),
              let toBed = object.toBed,
              let wakeUp = object.wakeUp,
              let targetToBed = object.targetToBed,
              let targetWakeUp = object.targetWakeUp else {
            assertionFailure()
            return nil
        }
        self = .init(
            sleepDuration: Schedule.Minute(object.sleepDuration),
            intensity: intensity,
            toBed: toBed,
            wakeUp: wakeUp,
            targetToBed: targetToBed,
            targetWakeUp: targetWakeUp
        )
    }
}

fileprivate extension Date {
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
            format: "wakeUp >= %@ AND wakeUp =< %@",
            argumentArray: [startDate ?? Date(), endDate ?? Date()]
        )
    }
}
