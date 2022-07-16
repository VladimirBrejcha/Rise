//
//  ErrorViewCreatable.swift
//  Rise
//
//  Created by Vladimir Korolev on 18.08.2020.
//  Copyright © 2020 VladimirBrejcha. All rights reserved.
//

import Foundation
import Core

protocol ErrorViewCreatable: ErrorReasonExtractable {
  func makeErrorView(for error: Error) -> ErrorView
}

extension ErrorViewCreatable {
  func makeErrorView(for error: Error) -> ErrorView {
    if let recoverableError = error as? Core.RecoverableError {
      return makeRecoverableErrorView(for: recoverableError)
    }
    
    let defaultTitle = "Error"
    let description = errorReason(from: error)
    if let localizedError = error as? LocalizedError {
      return makeErrorView(
        title: localizedError.errorDescription ?? defaultTitle,
        message: description)
    }
    return makeErrorView(title: defaultTitle, message: description)
  }
  
  private func makeErrorView(
    title: String?,
    message: String?,
    actions: [ErrorView.Action] = []
  ) -> ErrorView {
    ErrorView(title: title, description: message, actions: actions)
  }
  
  private func makeRecoverableErrorView(for recoverableError: Core.RecoverableError) -> ErrorView {
    let title = recoverableError.errorDescription
    let message = errorReason(from: recoverableError)
    let actions = recoverableError.recoveryOptions.enumerated().map { (element) -> ErrorView.Action in
      ErrorView.Action(title: element.element) {
        recoverableError.attemptRecovery(optionIndex: element.offset)
      }
    }
    return makeErrorView(title: title, message: message, actions: actions)
  }
}
