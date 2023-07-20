import Foundation
import Core

public enum SunTimeError: LocalizedError {
  case networkError (underlyingError: Error)
  case internalError

  public var errorDescription: String? {
    switch self {
    case .networkError(let underlyingError):
      return "Network error: \(underlyingError.localizedDescription)"
    case .internalError:
      return "Internal error"
    }
  }
}
