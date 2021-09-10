//
//  invertAlpha.swift
//  Rise
//
//  Created by Vladimir Korolev on 04.04.2021.
//  Copyright © 2021 VladimirBrejcha. All rights reserved.
//

import UIKit

extension Array where Element == UIView {
    func invertAlpha(max: CGFloat = 1) {
        forEach { $0.alpha = max - $0.alpha }
    }
}
