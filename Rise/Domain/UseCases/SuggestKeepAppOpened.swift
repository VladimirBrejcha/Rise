//
//  SuggestKeepAppOpened.swift
//  Rise
//
//  Created by Vladimir Korolev on 23.11.2021.
//  Copyright © 2021 VladimirBrejcha. All rights reserved.
//

/*
 * Provides interface to get or set information about
 * wherever app should suggest to keep it opened while sleeping
 */
protocol SuggestKeepAppOpened {
    var shouldSuggest: Bool { get set }
}

final class SuggestKeepAppOpenedImpl: SuggestKeepAppOpened {
    private let userData: UserData

    var shouldSuggest: Bool {
        get { !userData.keepAppOpenedSuggested }
        set { userData.keepAppOpenedSuggested = !newValue }
    }

    init(_ userData: UserData) {
        self.userData = userData
    }
}
