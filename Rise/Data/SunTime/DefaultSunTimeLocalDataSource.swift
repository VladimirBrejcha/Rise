//
//  SunTimeLocalDataSource.swift
//  Rise
//
//  Created by Владимир Королев on 10.11.2019.
//  Copyright © 2019 VladimirBrejcha. All rights reserved.
//

import Foundation
import CoreData

fileprivate typealias ObjectType = RiseSunTime
fileprivate let containerName = "SunTimeData"

protocol <#name#> {
    <#requirements#>
}

class DefaultSunTimeLocalDataSource {
    private lazy var container: PersistentContainer<ObjectType> = {
        let container = PersistentContainer<ObjectType>(name: containerName)
        container.loadPersistentStores { description, error in
            if let error = error { fatalError("Unable to load persistent stores: \(error)") } }
        return container
    }()
    
    private let builder = SunTimeModelBuilder()
    
    private var context: NSManagedObjectContext { return container.viewContext }
    private let entityName = String(describing: ObjectType.self)
    
    func requestSunTime(for numberOfDays: Int, since day: Date) -> Result<[SunTime], Error> {
        var returnArray = [SunTime]()

        for iteration in 0...numberOfDays - 1 {
            guard let date = day.appending(days: iteration)
                else {
                    return .failure(RiseError.errorCantFormatDate())
            }

            let fetchResult = self.container.fetch(with: date.makeDayPredicate())

            if case .success (let sunTime) = fetchResult {
                returnArray.append(self.builder.buildModel(from: sunTime[0]))
            }

            if case .failure (let error) = fetchResult {
                log(.error, with: error.localizedDescription)
            }
            
            if iteration == numberOfDays - 1 {
                if returnArray.isEmpty { return .failure(RiseError.errorNoDataFound()) }
                return .success(returnArray)
            }
        }
        
        return .failure(RiseError.errorNoDataFound())
    }

    @discardableResult func create(sunTimes: [SunTime]) -> Bool {
        var correctlySaved = false
        
        sunTimes.forEach { sunTime in
            let sunTimeObject = NSEntityDescription.insertNewObject(forEntityName: entityName, into: context) as! ObjectType
            builder.update(object: sunTimeObject, with: sunTime)
            correctlySaved = container.saveContext()
        }
        
        return correctlySaved
    }

    @discardableResult func deleteAll() -> Bool {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        do {
            try context.execute(deleteRequest)
            try context.save()
            return true
        }
        catch {
            return false
        }
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
