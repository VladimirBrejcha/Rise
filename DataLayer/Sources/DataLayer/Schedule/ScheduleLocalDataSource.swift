import Foundation
import Core
import CoreData
import Combine

protocol ScheduleLocalDataSource {
    func get(for date: Date) throws -> Schedule
    func getLatest() throws -> Schedule
    func save(_ schedule: Schedule) throws
    func delete(for date: Date) throws
    func deleteLatest() throws
    func deleteAll() throws
    func publisher<T: NSManagedObject>(
        for managedObjectType: T.Type
    ) -> AnyPublisher<([(LocalDataSourceObjectChange, T)]), Never>
}

enum ScheduleLocalDataSourceError: Error {
    case noScheduleForTheDate
    case failedToRecreateSchedule
}
