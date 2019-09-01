//
//  CustomTabBar.swift
//  Rise
//
//  Created by Vladimir Korolev on 08/06/2019.
//  Copyright © 2019 VladimirBrejcha. All rights reserved.
//

import UIKit

final class CustomTabBar: UITabBar {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        sharedInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        sharedInit()
    }
    
    private func sharedInit() {
        UITabBar.appearance().backgroundImage = #colorLiteral(red: 0.9953911901, green: 0.9881951213, blue: 1, alpha: 0.1007922535).image()
        UITabBar.appearance().shadowImage = UIImage()
    }
    
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
