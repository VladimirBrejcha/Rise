//
//  UIButton+Styled.swift
//  Rise
//
//  Created by Владимир Королев on 04.04.2021.
//  Copyright © 2021 VladimirBrejcha. All rights reserved.
//

import UIKit

protocol StyledButton: UIButton, Styleable {
    var style: Style.Button { get set }
}

extension StyledButton {
    func applyStyle(_ style: Style.Button) {
        self.style = style
        self.backgroundColor = style.backgroundColor
        self.layer.applyStyle(style.effects)
        self.setTitleColor(style.titleStyle.color, for: .normal)
        self.setTitleColor(style.disabledTitleColor, for: .disabled)
        self.titleLabel?.font = style.titleStyle.font
    }
}
