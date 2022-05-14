//
//  PreferredWakeUpTime.swift
//  Rise
//
//  Created by Vladimir Korolev on 22.11.2021.
//  Copyright © 2021 VladimirBrejcha. All rights reserved.
//

import Foundation

protocol HasPreferredWakeUpTimeUseCase {
  var preferredWakeUpTime: PreferredWakeUpTime { get }
}

/*
 * Provides preferred wake up time in case if user have no schedule
 */
protocol PreferredWakeUpTime: AnyObject {
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
