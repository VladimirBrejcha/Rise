//
//  StyledButton.swift
//  Rise
//
//  Created by Владимир Королев on 02.04.2021.
//  Copyright © 2021 VladimirBrejcha. All rights reserved.
//

import UIKit

extension CALayer: Styleable {
    func applyStyle(_ style: Style.Layer) {
        self.cornerRadius = style.cornerRadius
        self.shadowColor = style.shadow.color
        self.shadowRadius = style.shadow.radius
        self.shadowOpacity = style.shadow.opacity
        self.shadowOffset = style.shadow.offset
        self.borderWidth = style.border.width
        self.borderColor = style.border.color
    }
}
