//
//  SettingsViewController.swift
//  Rise
//
//  Created by Vladimir Korolev on 03/06/2019.
//  Copyright © 2019-2020 VladimirBrejcha. All rights reserved.
//

import UIKit

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
            selectionHandler: { [weak self] identifier in
                guard let self = self else { return }

                self.settingsView.deselectAll()
                
                switch identifier {
                case .onboarding:
                    self.present(Story.onboarding(dismissOnCompletion: true)(), with: .fullScreen)
                case .about:
                    self.present(Story.about(), with: .modal)
                default:
                    print(identifier)
                }
            }
        )
    }
}
