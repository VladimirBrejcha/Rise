import Foundation
import DataLayer

public protocol HasDeleteSchedule {
  var deleteSchedule: DeleteSchedule { get }
}

public protocol DeleteSchedule {
  func callAsFunction()
}

final class DeleteScheduleImpl: DeleteSchedule {

  private let scheduleRepository: ScheduleRepository
  private let userData: UserData

  init(_ scheduleRepository: ScheduleRepository,
       _ userData: UserData
  ) {
    self.scheduleRepository = scheduleRepository
    self.userData = userData
  }

  func callAsFunction() {
    scheduleRepository.deleteAll()
    userData.scheduleOnPause = false
  }
}
