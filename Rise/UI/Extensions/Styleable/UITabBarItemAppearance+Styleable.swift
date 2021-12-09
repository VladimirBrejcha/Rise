//
//  UITabBarItemAppearance+Styled.swift
//  Rise
//
//  Created by Vladimir Korolev on 04.04.2021.
//  Copyright © 2021 VladimirBrejcha. All rights reserved.
//

import UIKit

extension UITabBarItemAppearance: Styleable {
    func applyStyle(_ style: Rise.Style.TabBar.Item) {
        normal.iconColor = style.iconColor.normal
        selected.iconColor = style.iconColor.selected
    }
}
