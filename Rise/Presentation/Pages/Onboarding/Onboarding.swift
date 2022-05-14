//
//  Onboarding.swift
//  Rise
//
//  Created by Vladimir Korolev on 14.05.2022.
//  Copyright © 2022 VladimirBrejcha. All rights reserved.
//

enum Onboarding { }

extension Onboarding {
  static var defaultParams: Controller.Params {
    [
      .init(
        title: Text.Onboarding.Title.sleepIsImportant,
        descriptions: [
          Text.Onboarding.aboutSleep,
          Text.Onboarding.aboutSleep2,
          Text.Onboarding.aboutSleep3
        ]
      ),
      .init(
        title: Text.Onboarding.Title.haveYouScheduledIt,
        descriptions: [
          Text.Onboarding.missedAlarm,
          Text.Onboarding.unableToAdjust,
          Text.Onboarding.itHappensWithAllOfUs
        ]
      ),
      .init(
        title: Text.Onboarding.Title.meetRise,
        descriptions: [
          Text.Onboarding.personalAssistant,
          Text.Onboarding.personalAssistant2,
          Text.Onboarding.personalAssistant3
        ]
      ),
    ]
  }
}
