import DataLayer

public protocol HasSuggestKeepAppOpenedUseCase {
  var suggestKeepAppOpened: SuggestKeepAppOpened { get }
}

/*
 * Provides interface to get or set information about
 * wherever app should suggest to keep it opened while sleeping
 */
public protocol SuggestKeepAppOpened: AnyObject {
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
