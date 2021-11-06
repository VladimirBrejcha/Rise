//
//  DefaultUserData.swift
//  Rise
//
//  Created by Vladimir Korolev on 11.09.2021.
//  Copyright © 2021 VladimirBrejcha. All rights reserved.
//

final class DefaultUserData: UserData {
    @NonNilUserDefault("onboarding_completed", defaultValue: false)
    var onboardingCompleted: Bool

    @NonNilUserDefault("schedule_on_pause", defaultValue: false)
    var scheduleOnPause: Bool
}
