//
//  AlertPresentable.swift
//  Rise
//
//  Created by Vladimir Korolev on 18.08.2020.
//  Copyright © 2020 VladimirBrejcha. All rights reserved.
//

import UIKit

protocol AlertPresentable: AnyObject {
    func presentAlert(from error: Error)
    func presentAreYouSureAlert(text: String, action: UIAlertAction)
}

extension AlertPresentable where Self: AlertCreatable & UIViewController {
    func presentAlert(from error: Error) {
        present(makeAlert(for: error), animated: true)
    }

    func presentAreYouSureAlert(text: String, action: UIAlertAction) {
        present(makeAreYouSureAlert(text: text, action: action), animated: true)
    }
}
