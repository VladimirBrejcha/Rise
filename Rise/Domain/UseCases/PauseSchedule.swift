//
//  PauseSchedule.swift
//  Rise
//
//  Created by Vladimir Korolev on 06.11.2021.
//  Copyright © 2021 VladimirBrejcha. All rights reserved.
//

protocol HasPauseScheduleUseCase {
  var pauseSchedule: PauseSchedule { get }
}

protocol PauseSchedule {
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
