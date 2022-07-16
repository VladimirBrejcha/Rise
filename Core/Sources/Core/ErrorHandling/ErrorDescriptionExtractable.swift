import Foundation

public protocol ErrorReasonExtractable {
  func errorReason(from error: Error) -> String?
}

public extension ErrorReasonExtractable {
  func errorReason(from error: Error) -> String? {
    if let localizedError = error as? LocalizedError {
      return localizedError.recoverySuggestion
    }
    return "Something bad happened. Please try again"
  }
}
