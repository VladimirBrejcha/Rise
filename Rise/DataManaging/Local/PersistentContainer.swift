//
//  PersistentContainer.swift
//  Rise
//
//  Created by Владимир Королев on 14.10.2019.
//  Copyright © 2019 VladimirBrejcha. All rights reserved.
//

import Foundation
import CoreData

class PersistentContainer: NSPersistentContainer {
    
    func saveContext(backgroundContext: NSManagedObjectContext? = nil) {
        let context = backgroundContext ?? viewContext
        guard context.hasChanges else { return }
        do { try context.save() }
        catch { print("Error: \(error.localizedDescription)") }
    }
    
    // MARK: - Personal Plan
    func fetchPersonalPlan() -> Result<RisePersonalPlan, Error> {
        let fetchRequest: NSFetchRequest<RisePersonalPlan> = RisePersonalPlan.fetchRequest()
        do {
            let fetchedResult = try viewContext.fetch(fetchRequest)
            guard let result = fetchedResult.first else { return .failure(RiseError.errorNoDataFound()) }
            return(.success(result)) }
        catch { return .failure(error) }
    }
    
    // MARK: - Sun Time
    func fetchSunTime(for day: Date) -> Result<RiseSunTime, Error> {
        let fetchRequest: NSFetchRequest<RiseSunTime> = RiseSunTime.fetchRequest()
        do {
            fetchRequest.predicate = day.makeDayPredicate()
            let fetchedResult = try viewContext.fetch(fetchRequest)
            guard let result = fetchedResult.first else { return .failure(RiseError.errorNoDataFound()) }
            return .success(result) }
        catch { return .failure(error) }
    }
    
}

fileprivate extension Date {
    func makeDayPredicate() -> NSPredicate {
        let calendar = Calendar.current
        var components = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: self)
        components.hour = 00
        components.minute = 00
        components.second = 00
        let startDate = calendar.date(from: components)
        components.hour = 23
        components.minute = 59
        components.second = 59
        let endDate = calendar.date(from: components)
        return NSPredicate(format: "day >= %@ AND day =< %@", argumentArray: [startDate!, endDate!])
    }
}
