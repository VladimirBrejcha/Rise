//
//  AlertCreatable.swift
//  Rise
//
//  Created by Vladimir Korolev on 18.08.2020.
//  Copyright © 2020 VladimirBrejcha. All rights reserved.
//

import UIKit

protocol AlertCreatable: AnyObject, ErrorReasonExtractable {
    func makeAlert(for error: Error) -> UIAlertController
    func makeDefaultAlert(with text: String) -> UIAlertController
}

extension AlertCreatable where Self: UIViewController {
    func makeAlert(for error: Error) -> UIAlertController {
        if let recoverableError = error as? RecoverableError {
            return makeRecoverableAlert(for: recoverableError)
        }
        
        let defaultTitle = "Error"
        let description = errorReason(from: error)
        
        if let localizedError = error as? LocalizedError {
            return makeAlert(
                title: localizedError.errorDescription ?? defaultTitle,
                message: description,
                actions: [.okAction]
            )
        }

        return makeAlert(
            title: defaultTitle,
            message: description,
            actions: [.okAction]
        )
    }
    
    private func makeAlert(
        title: String?,
        message: String?,
        actions: [UIAlertAction]
    ) -> UIAlertController {
        let alertViewController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        actions.forEach(alertViewController.addAction)
        return alertViewController
    }

    private func makeRecoverableAlert(
        for recoverableError: RecoverableError
    ) -> UIAlertController {
        let title = recoverableError.errorDescription
        let message = errorReason(from: recoverableError)
        let actions = recoverableError.recoveryOptions.enumerated().map { (element) -> UIAlertAction in
            let style: UIAlertAction.Style = element.offset == 0
                ? .cancel
                : .default
            return UIAlertAction(title: element.element, style: style) { _ in
                recoverableError.attemptRecovery(optionIndex: element.offset)
            }
        }
        return makeAlert(title: title, message: message, actions: actions)
    }

    func makeDefaultAlert(with text: String) -> UIAlertController {
        makeAlert(title: text, message: nil, actions: [.okAction])
    }
}

extension UIAlertAction {
    static let okAction = UIAlertAction(title: "Ok", style: .cancel) { _ in }
}
