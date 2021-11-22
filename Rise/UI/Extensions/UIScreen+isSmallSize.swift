//
//  UIScreen+isSmallSize.swift
//  Rise
//
//  Created by Vladimir Korolev on 22.11.2021.
//  Copyright © 2021 VladimirBrejcha. All rights reserved.
//

import UIKit

extension UIScreen {
    /* iPhone SE and smaller */
    static var isSmallSize: Bool {
        main.bounds.height <= 568
    }
}
