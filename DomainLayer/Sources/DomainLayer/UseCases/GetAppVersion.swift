import Foundation

public protocol HasGetAppVersion {
  var getAppVersion: GetAppVersion { get }
}

public protocol GetAppVersion {
  func callAsFunction() -> String?
}

final class GetAppVersionUseCase: GetAppVersion {
  func callAsFunction() -> String? {
    if let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String,
       let buildVersion = Bundle.main.infoDictionary?["CFBundleVersion"] as? String {
      return "\(appVersion) (\(buildVersion))"
    }
    return nil
  }
}
