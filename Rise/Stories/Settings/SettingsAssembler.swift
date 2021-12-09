//
//  SettingsAssembler.swift
//  Rise
//
//  Created by Vladimir Korolev on 06.01.2020.
//  Copyright © 2020 VladimirBrejcha. All rights reserved.
//

import UIKit

final class SettingsAssembler {
    func assemble() -> SettingsViewController {
        let vc = SettingsViewController(
            getSchedule: DomainLayer.getSchedule
        )
        vc.tabBarItem = UITabBarItem.withSystemIcons(
            normal: "gearshape",
            selected: "gearshape.fill"
        )
        return vc
    }
}
