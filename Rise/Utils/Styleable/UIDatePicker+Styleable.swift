//
//  UIDatePicker+Styleable.swift
//  Rise
//
//  Created by Владимир Королев on 04.04.2021.
//  Copyright © 2021 VladimirBrejcha. All rights reserved.
//

import UIKit

extension UIDatePicker: Styleable {
    func applyStyle(_ style: Style.Picker) {
        setValue(style.textColor, forKey: "textColor")
        setValue(style.lineColor, forKey: "magnifierLineColor")
    }
}
