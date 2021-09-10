//
//  ErrorAlertPresentable.swift
//  Rise
//
//  Created by Vladimir Korolev on 18.08.2020.
//  Copyright © 2020 VladimirBrejcha. All rights reserved.
//

import UIKit

protocol ErrorAlertPresentable: AnyObject {
    func presentAlert(from error: Error)
    func presentAlertAboveAll(from error: Error)
}

extension ErrorAlertPresentable where Self: ErrorAlertCreatable & UIViewController {
    func presentAlert(from error: Error) {
        present(makeAlert(for: error, aboveAll: false), animated: true)
    }

    func presentAlertAboveAll(from error: Error) {
        let alertVC = makeAlert(for: error, aboveAll: true)
        if let alertVC = alertVC as? AboveAllAlertController {
            alertVC.show()
            return
        }
        assert(false, "Should create AboveAllAlertController")
        present(alertVC, animated: true, completion: nil)
    }
}
