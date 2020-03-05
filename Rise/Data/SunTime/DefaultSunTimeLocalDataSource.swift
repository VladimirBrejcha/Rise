//
//  SunTimeLocalDataSource.swift
//  Rise
//
//  Created by Владимир Королев on 10.11.2019.
//  Copyright © 2019 VladimirBrejcha. All rights reserved.
//

import Foundation
import CoreData

protocol SunTimeLocalDataSource {
    func get(for numberOfDays: Int, since day: Date) throws -> [SunTime]
    func save(sunTimes: [SunTime]) throws
    func deleteAll() throws
}

final class DefaultSunTimeLocalDataSource: LocalDataSource<RiseSunTime>, SunTimeLocalDataSource {
    func get(for numberOfDays: Int, since day: Date) throws -> [SunTime] {
        var returnArray = [SunTime]()
        
        for iteration in 1...numberOfDays {
            guard let date = day.appending(days: iteration - 1)
                else {
                    log(.warning, with: RiseError.errorCantFormatDate().localizedDescription)
                    continue
            }
            let fetchResult = try container.fetch(with: date.makeDayPredicate())
            if fetchResult.isEmpty { continue }
            returnArray.append(buildModel(from: fetchResult[0]))
        }
        
        return returnArray
    }

    func save(sunTimes: [SunTime]) throws {
        try sunTimes.forEach { sunTime in
            let sunTimeObject = insertObject()
            update(object: sunTimeObject, with: sunTime)
            try container.saveContext()
        }
    }

    func deleteAll() throws {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        try context.execute(deleteRequest)
        try context.save()
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
    func makeDayPredicate() -> NSPredicate {
        var components = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: self)
        components.hour = 00
        components.minute = 00
        components.second = 00
        let startDate = calendar.date(from: components)
        components.hour = 23
        components.minute = 59
        components.second = 59
        let endDate = calendar.date(from: components)
        return NSPredicate(format: "sunrise >= %@ AND sunrise =< %@", argumentArray: [startDate!, endDate!])
    }
}
