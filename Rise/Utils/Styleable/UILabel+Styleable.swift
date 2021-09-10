//
//  UILabel+Styled.swift
//  Rise
//
//  Created by Vladimir Korolev on 04.04.2021.
//  Copyright © 2021 VladimirBrejcha. All rights reserved.
//

import UIKit

extension UILabel: Styleable {
    func applyStyle(_ style: Style.Text) {
        self.font = style.font
        if let color = style.color {
            self.textColor = color
        }
        if let alignment = style.alignment {
            self.textAlignment = alignment
        }
    }
}
