//
//  Button.swift
//  Rise
//
//  Created by Владимир Королев on 10.10.2019.
//  Copyright © 2019-2020 VladimirBrejcha. All rights reserved.
//

import UIKit

@IBDesignable
class Button: UIButton, PropertyAnimatable, TouchObservable {
    var propertyAnimationDuration: Double = 0.1
    
    var onTouchDown: ((Button) -> Void)?
    var onTouchUp: ((Button) -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configure()
    }
    
    func configure() {
        addTarget(self, action: #selector(touchDown(_:)), for: [.touchDown, .touchDragInside])
        addTarget(self, action: #selector(touchUp(_:)), for: [.touchUpInside, .touchDragOutside, .touchCancel])
    }
    
    @objc private func touchDown(_ sender: UIButton) {
        animate {
            sender.transform = Styles.Button.scaleTransform
        }
        onTouchDown?(self)
    }
    
    @objc private func touchUp(_ sender: UIButton) {
        animate {
            sender.transform = CGAffineTransform.identity
        }
        onTouchUp?(self)
    }
}
