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
    
    var touchDownObserver: ((Button) -> Void)?
    var touchUpObserver: ((Button) -> Void)?

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
        addTarget(self, action: #selector(touchDown(_:)), for: [.touchDown, .touchDragInside])
        addTarget(self, action: #selector(touchUp(_:)), for: [.touchUpInside, .touchDragOutside, .touchCancel])
        setTitleColor(Color.normalTitle, for: .normal)
        setTitleColor(Color.disabledTitle, for: .disabled)
    }
    
    @objc private func touchDown(_ sender: UIButton) {
        animate {
            sender.transform = CGAffineTransform(scaleX: 0.93, y: 0.93)
        }
        touchDownObserver?(self)
    }
    
    @objc private func touchUp(_ sender: UIButton) {
        animate {
            sender.transform = CGAffineTransform.identity
        }
        touchUpObserver?(self)
    }
}
