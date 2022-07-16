import Foundation
import Core

protocol ScheduleLocalDataSource {
  func get(for date: Date) throws -> Schedule
  func getLatest() throws -> Schedule
  func save(_ schedule: Schedule) throws
  func delete(for date: Date) throws
  func deleteLatest() throws
  func deleteAll() throws
}

enum ScheduleLocalDataSourceError: Error {
  case noScheduleForTheDate
  case failedToRecreateSchedule
}
