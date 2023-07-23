import Foundation

public protocol HasGetAppVersion {
  var getAppVersion: GetAppVersion { get }
}

public protocol GetAppVersion {
  func callAsFunction() -> String?
}

final class GetAppVersionImpl: GetAppVersion {
  func callAsFunction() -> String? {
    if let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
      return "\(appVersion)"
    }
    return nil
  }
}
