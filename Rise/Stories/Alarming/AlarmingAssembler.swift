//
//  AlarmingAssembler.swift
//  Rise
//
//  Created by Vladimir Korolev on 08.01.2021.
//  Copyright © 2021 VladimirBrejcha. All rights reserved.
//

import Foundation

final class AlarmingAssembler {
    func assemble() -> AlarmingViewController {
        AlarmingViewController(
            changeScreenBrightness: DomainLayer.changeScreenBrightness
        )
    }
}
