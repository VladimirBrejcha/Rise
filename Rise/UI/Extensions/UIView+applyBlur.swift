//
//  applyBlur.swift
//  Rise
//
//  Created by Vladimir Korolev on 04.04.2021.
//  Copyright © 2021 VladimirBrejcha. All rights reserved.
//

import UIKit

extension UIView {
    func applyBlur(style: UIBlurEffect.Style) {
        let blur = UIBlurEffect(style: style)
        let view = UIVisualEffectView(effect: blur)
        view.layer.masksToBounds = true
        addSubview(view)
        sendSubviewToBack(view)
        view.activateConstraints(edgesTo(self))
    }
}
