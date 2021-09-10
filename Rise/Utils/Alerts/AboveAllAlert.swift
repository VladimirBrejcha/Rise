//
//  AboveAllAlert.swift
//  Rise
//
//  Created by Vladimir Korolev on 18.08.2020.
//  Copyright © 2020 VladimirBrejcha. All rights reserved.
//

import UIKit

final class AboveAllAlertController: UIAlertController {
    var alertWindow: UIWindow { AppDelegate.alertWindow }

    func show() {
        let topWindow = UIApplication.shared.windows.last
        if let topWindow = topWindow {
            alertWindow.windowLevel = topWindow.windowLevel + 1
        }
        alertWindow.makeKeyAndVisible()
        alertWindow.rootViewController?.present(self, animated: true)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        alertWindow.isHidden = true
    }
}
