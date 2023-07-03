import DataLayer
import Core

public protocol HasSaveSchedule {
    var saveSchedule: SaveSchedule { get }
}

public protocol SaveSchedule {
    func callAsFunction(_ schedule: Schedule)
}

final class SaveScheduleImpl: SaveSchedule {
  private let scheduleRepository: ScheduleRepository

  init(_ scheduleRepository: ScheduleRepository) {
    self.scheduleRepository = scheduleRepository
  }

  func callAsFunction(_ schedule: Schedule) {
    scheduleRepository.save(schedule)
  }
}
