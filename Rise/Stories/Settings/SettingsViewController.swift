//
//  SettingsViewController.swift
//  Rise
//
//  Created by Vladimir Korolev on 03/06/2019.
//  Copyright © 2019-2020 VladimirBrejcha. All rights reserved.
//

import UIKit

final class SettingsViewController: UIViewController {

    private var settingsView: SettingsView {
        view as! SettingsView
    }
    private let getSchedule: GetSchedule
    private var schedule: Schedule? {
        getSchedule.today()
    }

    init(getSchedule: GetSchedule) {
        self.getSchedule = getSchedule
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("This class does not support NSCoder")
    }

    override func loadView() {
        super.loadView()
        self.view = SettingsView(
            selectionHandler: { [weak self] identifier in
                guard let self = self else { return }

                self.settingsView.deselectAll()
                
                switch identifier {
                case .editSchedule:
                    if let schedule = self.schedule {
                        self.navigationController?.pushViewController(
                            Story.editSchedule(schedule: schedule)(),
                            animated: true
                        )
                    } else {
                        assertionFailure("Attempted to present editSchedule without schedule")
                    }
                case .adjustBedTime:
                    if let schedule = self.schedule {
                        self.present(
                            Story.adjustSchedule(
                                currentSchedule: schedule)(),
                            with: .fullScreen
                        )
                    } else {
                        assertionFailure("Attempted to present editSchedule without schedule")
                    }
                case .onboarding:
                    self.navigationController?.pushViewController(
                        Story.onboarding(),
                        animated: true
                    )
                case .about:
                    self.present(Story.about(), with: .modal)
                case .refreshSuntime:
                    self.present(Story.refreshSunTime(), with: .modal)
                }
            }
        )
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        settingsView.reconfigure(with: models)
    }

    private var models: [SettingsView.ItemView.Model] {
        var result: [SettingsView.ItemView.Model] = []
        if schedule != nil {
            result.append(.init(
                identifier: .editSchedule,
                image: UIImage.init(systemName: "calendar")!,
                title: Text.Settings.Title.editSchedule,
                description: Text.Settings.Description.editSchedule
            ))
            result.append(.init(
                identifier: .adjustBedTime,
                image: UIImage(systemName: "bed.double.fill")!,
                title: Text.adjustSchedule,
                description: Text.adjustScheduleShortDescription
            ))
        }
        result.append(contentsOf: [
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
        ])
        return result
    }
}
