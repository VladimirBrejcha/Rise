//
//  ErrorAlertCreatable.swift
//  Rise
//
//  Created by Vladimir Korolev on 18.08.2020.
//  Copyright © 2020 VladimirBrejcha. All rights reserved.
//

import UIKit

protocol ErrorAlertCreatable: AnyObject, ErrorReasonExtractable {
    func makeAlert(for error: Error, aboveAll: Bool) -> UIAlertController
    func makeDefaultAlert(with text: String) -> UIAlertController
}

extension ErrorAlertCreatable where Self: UIViewController {
    func makeAlert(for error: Error, aboveAll: Bool) -> UIAlertController {
        if let recoverableError = error as? RecoverableError {
            return makeRecoverableAlert(for: recoverableError, aboveAll: aboveAll)
        }
        
        let defaultTitle = "Error"
        let description = errorReason(from: error)
        
        if let localizedError = error as? LocalizedError {
            return makeAlert(
                title: localizedError.errorDescription ?? defaultTitle,
                message: description,
                actions: [.defaultAction],
                aboveAll: aboveAll
            )
        }

        return makeAlert(
            title: defaultTitle, message: description,
            actions: [.defaultAction], aboveAll: aboveAll
        )
    }
    
    private func makeAlert(
        title: String?,
        message: String?,
        actions: [UIAlertAction],
        aboveAll: Bool
    ) -> UIAlertController {
        let alertViewController = aboveAll
            ? AboveAllAlertController(title: title, message: message, preferredStyle: .alert)
            : UIAlertController(title: title, message: message, preferredStyle: .alert)
        actions.forEach { alertViewController.addAction($0) }
        return alertViewController
    }

    private func makeRecoverableAlert(
        for recoverableError: RecoverableError,
        aboveAll: Bool
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
        return makeAlert(title: title, message: message, actions: actions, aboveAll: aboveAll)
    }

    func makeDefaultAlert(with text: String) -> UIAlertController {
        makeAlert(title: text, message: nil, actions: [.defaultAction], aboveAll: false)
    }
}

extension UIAlertAction {
    static let defaultAction = UIAlertAction(title: "Ok", style: .cancel) { _ in }
}
