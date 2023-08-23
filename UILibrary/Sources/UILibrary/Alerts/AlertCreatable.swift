import UIKit
import Core

public protocol AlertCreatable: AnyObject, ErrorReasonExtractable {
    func makeAlert(for error: Error) -> UIAlertController
    func makeAlert(
        title: String?,
        message: String?,
        actions: [UIAlertAction]
    ) -> UIAlertController
    func makeAreYouSureAlert(text: String, action: UIAlertAction) -> UIAlertController
}

extension AlertCreatable where Self: UIViewController {
    
    public func makeAlert(for error: Error) -> UIAlertController {
        if let recoverableError = error as? Core.RecoverableError {
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

    public func makeAreYouSureAlert(text: String, action: UIAlertAction) -> UIAlertController {
        makeAlert(title: "Are you sure?", message: text, actions: [action, .cancelAction])
    }

    public func makeAlert(
        title: String?,
        message: String?,
        actions: [UIAlertAction]
    ) -> UIAlertController {
        let alertViewController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        actions.forEach(alertViewController.addAction)
        return alertViewController
    }

    private func makeRecoverableAlert(
        for recoverableError: Core.RecoverableError
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
}

extension UIAlertAction {
    static let okAction = UIAlertAction(title: "Ok", style: .cancel) { _ in }
    static let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in }
}
