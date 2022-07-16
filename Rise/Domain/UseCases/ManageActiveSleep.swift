//
//  ManageActiveSleep.swift
//  Rise
//
//  Created by Vladimir Korolev on 06.12.2021.
//  Copyright © 2021 VladimirBrejcha. All rights reserved.
//

import Foundation
import DataLayer

protocol HasManageActiveSleepUseCase {
  var manageActiveSleep: ManageActiveSleep { get }
}

/*
 * Provides start and end dates for active sleep (if exists)
 * Provides method to end sleep and therefore invalidates sleep dates
 */
protocol ManageActiveSleep: AnyObject {
  var sleepStartedAt: Date? { get set }
  var alarmAt: Date? { get set }
  func endSleep()
}

final class ManageActiveSleepImpl: ManageActiveSleep {

  private let userData: UserData

  var sleepStartedAt: Date? {
    get { userData.activeSleepStartDate }
    set { userData.activeSleepStartDate = newValue }
  }
  var alarmAt: Date? {
    get { userData.activeSleepEndDate }
    set { userData.activeSleepEndDate = newValue }
  }

  init(_ userData: UserData) {
    self.userData = userData
  }

  func endSleep() {
    userData.invalidateActiveSleep()
  }
}
