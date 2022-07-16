import Foundation

public enum PermissionError: LocalizedError {
  case locationAccessDenied

  public var errorDescription: String? {
    "Access to location was not granted"
  }

  public var recoverySuggestion: String? {
    "Please allow the app to access location"
  }
}
