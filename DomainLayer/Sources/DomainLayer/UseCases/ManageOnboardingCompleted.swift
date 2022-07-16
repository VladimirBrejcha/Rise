import DataLayer

public protocol HasManageOnboardingCompleted {
  var manageOnboardingCompleted: ManageOnboardingCompleted { get }
}

public protocol ManageOnboardingCompleted: AnyObject {
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
