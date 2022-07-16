import Foundation
import DataLayer

public protocol HasPreferredWakeUpTimeUseCase {
  var preferredWakeUpTime: PreferredWakeUpTime { get }
}

/*
 * Provides preferred wake up time in case if user have no schedule
 */
public protocol PreferredWakeUpTime: AnyObject {
  var time: Date? { get set }
}

final class PreferredWakeUpTimeImpl: PreferredWakeUpTime {

  private let userData: UserData

  var time: Date? {
    get { userData.preferredWakeUpTime }
    set { userData.preferredWakeUpTime = newValue }
  }

  init(_ userData: UserData) {
    self.userData = userData
  }
}
