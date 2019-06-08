//
//  CustomTabBar.swift
//  Rise
//
//  Created by Vladimir Korolev on 08/06/2019.
//  Copyright © 2019 VladimirBrejcha. All rights reserved.
//

import UIKit

final class CustomTabBar: UITabBar {
    
    // MARK: Properties
    @IBInspectable var height: CGFloat = 0.0
    
    // MARK: Methods
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        var sizeThatFits = super.sizeThatFits(size)
        if height > 0.0 {
            sizeThatFits.height = height + (UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0.0)
        }
        return sizeThatFits
    }
    
}
