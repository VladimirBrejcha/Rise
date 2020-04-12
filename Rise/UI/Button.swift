//
//  Button.swift
//  Rise
//
//  Created by Владимир Королев on 10.10.2019.
//  Copyright © 2019 VladimirBrejcha. All rights reserved.
//

import UIKit

@IBDesignable
final class Button: UIButton, PropertyAnimatable, Touchable {
    var propertyAnimationDuration: Double = 0.1
    
    var touchStarted: ((Button) -> Void)?
    var touchCancelled: ((Button) -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        sharedInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        sharedInit()
    }
    
    private func sharedInit() {
        backgroundColor = Color.defaultButtonBackground
        layer.cornerRadius = 12
        setTitleColor(Color.normalTitle, for: .normal)
        setTitleColor(Color.disabledTitle, for: .disabled)
        addTarget(self, action: #selector(touchUp(_:)), for: [.touchDragOutside,
                                                              .touchCancel,
                                                              .touchUpInside,
                                                              .touchUpOutside])
        addTarget(self, action: #selector(touchDown(_:)), for: [.touchDown,
                                                                .touchDragInside])
    }
    
    @objc func touchDown(_ sender: UIButton) {
        touchStarted?(self)
        animate {
            sender.transform = CGAffineTransform(scaleX: 0.93, y: 0.93)
        }
    }
    
    @objc func touchUp(_ sender: UIButton) {
        touchCancelled?(self)
        animate {
            sender.transform = CGAffineTransform.identity
        }
    }
}
