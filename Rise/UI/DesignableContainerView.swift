//
//  DesignableContainerView.swift
//  Rise
//
//  Created by Владимир Королев on 08/09/2019.
//  Copyright © 2019 VladimirBrejcha. All rights reserved.
//

import UIKit

@IBDesignable
class DesignableContainerView: UIView {
    @IBInspectable var cornerRadius: CGFloat {
        get { return layer.cornerRadius }
        set { layer.cornerRadius = newValue }
    }
    
    @IBInspectable var background: UIColor? {
        get { return backgroundColor }
        set { backgroundColor = newValue }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        sharedInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        sharedInit()
    }
    
    private func sharedInit() {
        background = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.03)
        cornerRadius = 12
        clipsToBounds = true
    }
}

