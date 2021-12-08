//
//  UINavigationController+replaceAllOnTopOfRoot.swift
//  Rise
//
//  Created by Vladimir Korolev on 09.12.2021.
//  Copyright © 2021 VladimirBrejcha. All rights reserved.
//

import UIKit

extension UINavigationController {
    func replaceAllOnTopOfRoot(with controller: UIViewController) {
        setViewControllers(
            [viewControllers.first, controller].compactMap { $0 },
            animated: true
        )
    }
}
