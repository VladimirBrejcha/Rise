//
//  UIButton+Styled.swift
//  Rise
//
//  Created by Vladimir Korolev on 04.04.2021.
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
        if let effects = style.effects {
            self.layer.applyStyle(effects)
        }
        self.setTitleColor(style.selectedTitleColor, for: .selected)
        self.setTitleColor(style.titleStyle.color, for: .normal)
        self.setTitleColor(style.disabledTitleColor, for: .disabled)
        self.titleLabel?.font = style.titleStyle.font
    }
}
