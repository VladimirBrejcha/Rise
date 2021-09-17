//
//  DesignableContainerView.swift
//  Rise
//
//  Created by Vladimir Korolev on 08/09/2019.
//  Copyright © 2019-2020 VladimirBrejcha. All rights reserved.
//

import UIKit

@IBDesignable
class DesignableContainerView: UIView {
    @IBInspectable var cornerRadius: CGFloat {
        get { layer.cornerRadius }
        set { layer.cornerRadius = newValue }
    }
    
    @IBInspectable var background: UIColor? {
        get { backgroundColor }
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
        background = Asset.Colors.defaultContainerBackground.color
        cornerRadius = 12
        layer.borderWidth = 1
        layer.borderColor = Asset.Colors.white.color.withAlphaComponent(0.85).cgColor
        clipsToBounds = true
    }
}

