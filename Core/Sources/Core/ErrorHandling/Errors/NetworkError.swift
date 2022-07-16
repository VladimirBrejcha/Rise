import Foundation

public enum NetworkError: LocalizedError {
  case urlSessionError (underlyingError: Error)
  case incorrectUrl (url: String)
  case responseParsingError (underlyingError: Error)
  case noDataReceived
  case internetError
  case internalError
  
  // MARK: - LocalizedError
  
  public var errorDescription: String? {
    switch self {
    case .incorrectUrl(let url):
      return "Incorrect url: \(url)"
    case .urlSessionError(let underlyingError):
      return "URLSession failed with error \(underlyingError.localizedDescription)"
    case .noDataReceived:
      return "Something bad happened"
    case  .responseParsingError(let underlyingError):
      return "Decoding failed with error: \(underlyingError.localizedDescription)"
    case .internetError:
      return "No internet connection"
    case .internalError:
      return "Internal error"
    }
  }
  
  public var recoverySuggestion: String? {
    switch self {
    case .internetError:
      return "Please check your internet connection"
    default:
      return nil
    }
  }
}
