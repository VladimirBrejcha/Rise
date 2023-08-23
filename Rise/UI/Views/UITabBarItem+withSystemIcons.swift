//
//  UITabBarItem+withSystemIcons.swift
//  Rise
//
//  Created by Vladimir Korolev on 09.12.2021.
//  Copyright © 2021 VladimirBrejcha. All rights reserved.
//

import UIKit

extension UITabBarItem {
    
    private static func config(size: CGFloat) -> UIImage.Configuration {
        UIImage.SymbolConfiguration(pointSize: size)
            .applying(
                UIImage.SymbolConfiguration(weight: .light)
            )
    }

    static func withSystemIcons(
        normal: String,
        selected: String,
        size: CGFloat = 23
    ) -> UITabBarItem {
        UITabBarItem(
            title: nil,
            image: UIImage(
                systemName: normal,
                withConfiguration: config(size: size)
            ),
            selectedImage: UIImage(
                systemName: selected,
                withConfiguration: config(size: size)
            )
        )
    }
}
