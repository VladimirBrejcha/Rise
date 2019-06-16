//
//  CustomContainerView.swift
//  Rise
//
//  Created by Vladimir Korolev on 15/06/2019.
//  Copyright © 2019 VladimirBrejcha. All rights reserved.
//

import UIKit

@IBDesignable
class CustomContainerView: UIView {

    @IBInspectable var cornerRadius: CGFloat {
        set { layer.cornerRadius = newValue }
        get { return layer.cornerRadius }
    }

}
