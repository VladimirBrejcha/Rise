//
//  Settings.swift
//  Rise
//
//  Created by Vladimir Korolev on 03.07.2022.
//  Copyright © 2022 VladimirBrejcha. All rights reserved.
//

import UIKit
import Localization

enum Settings {
    enum Setting {
        case selectAlarmMelody
        case editSchedule
        case adjustBedTime
        case refreshSuntime
        case onboarding
        case about
    }
}

extension Settings {
    static func prepareModels(hasSchedule: Bool) -> [View.ItemView.Model] {
        var result: [View.ItemView.Model] = []
        if hasSchedule {
            result.append(.init(
                setting: .editSchedule,
                image: UIImage.init(systemName: "calendar")!,
                title: Text.Settings.Title.editSchedule,
                description: Text.Settings.Description.editSchedule
            ))
            result.append(.init(
                setting: .adjustBedTime,
                image: UIImage(systemName: "bed.double.fill")!,
                title: Text.adjustSchedule,
                description: Text.adjustScheduleShortDescription
            ))
        }
        result.append(contentsOf: [
            .init(
                setting: .selectAlarmMelody,
                image: UIImage(systemName: "alarm.waves.left.and.right.fill")!,
                title: Text.Settings.Title.selectAlarmMelody,
                description: Text.Settings.Description.selectAlarmMelody
            ),
            .init(
                setting: .refreshSuntime,
                image: UIImage.init(systemName: "sun.max.fill")!,
                title: Text.Settings.Title.refresh,
                description: Text.Settings.Description.refresh
            ),
            .init(
                setting: .onboarding,
                image: UIImage.init(systemName: "graduationcap.fill")!,
                title: Text.Settings.Title.showOnboarding,
                description: Text.Settings.Description.showOnboarding
            ),
            .init(
                setting: .about,
                image: UIImage.init(systemName: "info.circle.fill")!,
                title: Text.Settings.Title.about,
                description: Text.Settings.Description.about
            ),
        ])
        return result
    }
}
