//
//  invertAlpha.swift
//  Rise
//
//  Created by Vladimir Korolev on 04.04.2021.
//  Copyright © 2021 VladimirBrejcha. All rights reserved.
//

import UIKit

extension UIView {
    func invertAlpha(max: CGFloat = 1) {
        alpha = max - alpha
    }
}

extension Array where Element == UIView {
    func invertAlpha(max: CGFloat = 1) {
        forEach { $0.invertAlpha() }
    }
}
