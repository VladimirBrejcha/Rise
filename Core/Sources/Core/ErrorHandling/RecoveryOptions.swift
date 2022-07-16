public enum RecoveryOptions {
  case tryAgain(action: (() -> Void))
  case custom(title: String, action: (() -> Void))
  case cancel

  var title: String {
    switch self {
    case .tryAgain:
      return "Try again"
    case .custom(let title, _):
      return title
    case .cancel:
      return "Cancel"
    }
  }
}
