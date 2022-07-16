import Foundation
import Core

public protocol ScheduleRepository {
  func get(for date: Date) -> Schedule?
  func getLatest() -> Schedule?
  func save(_ schedule: Schedule)
  func deleteAll()
}
