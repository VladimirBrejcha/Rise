//
//  ManageOnboardingCompleted.swift
//  Rise
//
//  Created by Vladimir Korolev on 11.09.2021.
//  Copyright © 2021 VladimirBrejcha. All rights reserved.
//

import DataLayer

protocol HasManageOnboardingCompleted {
  var manageOnboardingCompleted: ManageOnboardingCompleted { get }
}

protocol ManageOnboardingCompleted: AnyObject {
  var isCompleted: Bool { get set }
}

final class ManageOnboardingCompletedImpl: ManageOnboardingCompleted {
  
  private let userData: UserData
  
  var isCompleted: Bool {
    get { userData.onboardingCompleted }
    set { userData.onboardingCompleted = newValue }
  }
  
  init(_ userData: UserData) { self.userData = userData }
}
