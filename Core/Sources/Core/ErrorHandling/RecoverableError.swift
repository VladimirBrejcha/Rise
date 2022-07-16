import Foundation

public struct RecoverableError: Foundation.RecoverableError, LocalizedError {

  let error: Error
  let attempter: RecoveryAttempter

  var localizedError: LocalizedError? { error as? LocalizedError }

  public init(error: Error, attempter: RecoveryAttempter) {
    self.error = error
    self.attempter = attempter
  }

  // MARK: - Foundation.RecoverableError

  public var recoveryOptions: [String] { attempter.recoveryOptionsText }

  @discardableResult
  public func attemptRecovery(optionIndex recoveryOptionIndex: Int) -> Bool {
    attempter.attemptRecovery(fromError: error, optionIndex: recoveryOptionIndex)
  }

  public func attemptRecovery(optionIndex: Int, resultHandler: (Bool) -> Void) {
    resultHandler(attempter.attemptRecovery(fromError: error, optionIndex: optionIndex))
  }

  // MARK: - LocalizedError

  public var errorDescription: String? {
    localizedError?.errorDescription ?? "Something bad happened"
  }

  public var recoverySuggestion: String? {
    localizedError?.recoverySuggestion
  }
}
