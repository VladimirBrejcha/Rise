//
//  SleepAssembler.swift
//  Rise
//
//  Created by Vladimir Korolev on 13.03.2020.
//  Copyright © 2020 VladimirBrejcha. All rights reserved.
//

import Foundation

final class SleepAssembler {
    func assemble(alarm time: Date) -> SleepViewController {
        SleepViewController(
            alarmTime: time,
            preventAppSleep: DomainLayer.preventAppSleep,
            changeSleepBrightness: DomainLayer.changeScreenBrightness
        )
    }
}
