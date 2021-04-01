//
//  StyledButton.swift
//  Rise
//
//  Created by Владимир Королев on 02.04.2021.
//  Copyright © 2021 VladimirBrejcha. All rights reserved.
//

import UIKit

protocol StyledButton where Self: UIButton {
    var style: ButtonStyle { get set }
}

extension StyledButton {
    func applyStyle(_ style: ButtonStyle) {
        self.style = style
        self.backgroundColor = style.backgroundColor.normal
        self.layer.applyStyle(style.effects)
        self.setTitleColor(style.titleColor.normal, for: .normal)
        self.setTitleColor(style.titleColor.disabled, for: .disabled)
        self.titleLabel?.font = style.titleStyle.font
    }
}

extension CALayer {
    func applyStyle(_ style: LayerStyle) {
        self.cornerRadius = style.cornerRadius
        self.shadowColor = style.shadow.color
        self.shadowRadius = style.shadow.radius
        self.shadowOpacity = style.shadow.opacity
        self.shadowOffset = style.shadow.offset
        self.borderWidth = style.border.width
        self.borderColor = style.border.color
    }
}
