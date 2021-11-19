//
//  UISegmentedControl+Styleable.swift
//  Rise
//
//  Created by Vladimir Korolev on 19.11.2021.
//  Copyright © 2021 VladimirBrejcha. All rights reserved.
//

import UIKit

extension UISegmentedControl: Styleable {
    func applyStyle(_ style: Style.SegmentedControl) {
        selectedSegmentTintColor = style.selectionColor
        backgroundColor = style.backgroundColor
        setTitleTextAttributes(
            [NSAttributedString.Key.foregroundColor: style.normalTextColor],
            for: .normal
        )
        setTitleTextAttributes(
            [NSAttributedString.Key.foregroundColor: style.selectedTextColor],
            for: .selected
        )
    }
}
