//
//  SettingsViewController.swift
//  Rise
//
//  Created by Vladimir Korolev on 03/06/2019.
//  Copyright © 2019-2020 VladimirBrejcha. All rights reserved.
//

import UIKit

enum SettingIdentifier {
    case editSchedule
    case refreshSuntime
    case onboarding
    case about
}

final class SettingsViewController: UIViewController {

    private var settingsView: SettingsView { view as! SettingsView }

    override func loadView() {
        super.loadView()
        self.view = SettingsView(
            models: [
                .init(
                    identifier: .editSchedule,
                    image: UIImage.init(systemName: "calendar")!,
                    title: Text.Settings.Title.editSchedule,
                    description: Text.Settings.Description.editSchedule
                ),
                .init(
                    identifier: .refreshSuntime,
                    image: UIImage.init(systemName: "sun.max.fill")!,
                    title: Text.Settings.Title.refresh,
                    description: Text.Settings.Description.refresh
                ),
                .init(
                    identifier: .onboarding,
                    image: UIImage.init(systemName: "graduationcap.fill")!,
                    title: Text.Settings.Title.showOnboarding,
                    description: Text.Settings.Description.showOnboarding
                ),
                .init(
                    identifier: .about,
                    image: UIImage.init(systemName: "info.circle.fill")!,
                    title: Text.Settings.Title.about,
                    description: Text.Settings.Description.about
                ),
            ],
            selectionHandler: { identifier in
                switch identifier {
                default:
                    print(identifier)
                }
            }
        )
    }
}
