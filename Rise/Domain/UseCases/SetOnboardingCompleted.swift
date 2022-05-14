//
//  SetOnboardingCompleted.swift
//  Rise
//
//  Created by Vladimir Korolev on 11.09.2021.
//  Copyright © 2021 VladimirBrejcha. All rights reserved.
//

protocol HasSetOnboardingCompleted {
  var setOnboardingCompleted: SetOnboardingCompleted { get }
}

protocol SetOnboardingCompleted {
    func callAsFunction(_ completed: Bool)
}

final class SetOnboardingCompletedUseCase: SetOnboardingCompleted {
    private let userData: UserData

    init(_ userData: UserData) {
        self.userData = userData
    }
    
    func callAsFunction(_ completed: Bool) {
        userData.onboardingCompleted = completed
    }
}
