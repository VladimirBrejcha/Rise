//
//  DeleteSchedule.swift
//  Rise
//
//  Created by Vladimir Korolev on 07.11.2021.
//  Copyright © 2021 VladimirBrejcha. All rights reserved.
//

import Foundation

protocol HasDeleteScheduleUseCase {
  var deleteSchedule: DeleteSchedule { get }
}

protocol DeleteSchedule {
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
