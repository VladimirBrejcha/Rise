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
        let vc = SettingsViewController()
        vc.tabBarItem = UITabBarItem(
            title: nil,
            image: Asset.settings.image,
            selectedImage: Asset.settingsPressed.image
        )
        return vc
    }
}
