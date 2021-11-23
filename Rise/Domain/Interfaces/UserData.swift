//
//  UserData.swift
//  Rise
//
//  Created by Vladimir Korolev on 11.09.2021.
//  Copyright © 2021 VladimirBrejcha. All rights reserved.
//

import Foundation

protocol UserData: AnyObject {
    var onboardingCompleted: Bool { get set }
    var scheduleOnPause: Bool { get set }
    var latestAppUsageDate: Date? { get set }
    var preferredWakeUpTime: Date? { get set }
    var keepAppOpenedSuggested: Bool { get set }
}
