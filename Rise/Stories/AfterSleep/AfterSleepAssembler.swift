//  
//  AfterSleepAssembler.swift
//  Rise
//
//  Created by Vladimir Korolev on 24.11.2021.
//  Copyright © 2021 VladimirBrejcha. All rights reserved.
//

import Foundation

final class AfterSleepAssembler {
    func assemble() -> AfterSleepViewController {
        AfterSleepViewController(
            manageActiveSleep: DomainLayer.manageActiveSleep,
            getSchedule: DomainLayer.getSchedule
        )
    }
}
