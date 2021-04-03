//
//  UITabBarItemAppearance+Styled.swift
//  Rise
//
//  Created by Владимир Королев on 04.04.2021.
//  Copyright © 2021 VladimirBrejcha. All rights reserved.
//

import UIKit

extension UITabBarItemAppearance: Styled {
    func applyStyle(_ style: Rise.Style.TabBar.Item) {
        normal.iconColor = style.iconColor.normal
        normal.titleTextAttributes = [.foregroundColor: style.titleColor.normal]
        selected.titleTextAttributes = [.foregroundColor: style.titleColor.selected]
        selected.iconColor = style.iconColor.selected
    }
}
