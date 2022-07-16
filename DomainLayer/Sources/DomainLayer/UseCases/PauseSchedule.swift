import DataLayer

public protocol HasPauseSchedule {
  var pauseSchedule: PauseSchedule { get }
}

public protocol PauseSchedule {
  func callAsFunction(_ pause: Bool)
  var isOnPause: Bool { get }
}

final class PauseScheduleImpl: PauseSchedule {
  
  private let userData: UserData
  
  var isOnPause: Bool { userData.scheduleOnPause }
  
  init(_ userData: UserData) {
    self.userData = userData
  }
  
  func callAsFunction(_ pause: Bool) {
    userData.scheduleOnPause = pause
  }
}
