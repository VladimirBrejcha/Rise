//
//  Button.swift
//  Rise
//
//  Created by Vladimir Korolev on 10.10.2019.
//  Copyright © 2019-2020 VladimirBrejcha. All rights reserved.
//

import UIKit

@IBDesignable
class Button: UIButton, PropertyAnimatable, StyledButton {
    var propertyAnimationDuration: Double = 0.1

    var style: Style.Button = .primary
    
    var onTouchDown: ((Button) -> Void)?
    var onTouchUp: ((Button) -> Void)?
    var onAnyTouchDown: ((Button) -> Void)?
    var onAnyTouchUp: ((Button) -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configure()
    }
    
    private func configure() {
        applyStyle(style)
        addTarget(self, action: #selector(handleAnyTouchDown(_:)), for: [.touchDown, .touchDragInside])
        addTarget(self, action: #selector(handleAnyTouchUp(_:)), for: [.touchUpInside, .touchDragOutside, .touchCancel])
        addTarget(self, action: #selector(handleTouchDown(_:)), for: [.touchDown])
        addTarget(self, action: #selector(handleTouchUp(_:)), for: [.touchUpInside])
    }
    
    @objc private func handleAnyTouchDown(_ sender: UIButton) {
        onAnyTouchDown?(self)
        animate {
            sender.transform = CGAffineTransform(scaleX: 0.98, y: 0.95)
        }
    }
    
    @objc private func handleAnyTouchUp(_ sender: UIButton) {
        onAnyTouchUp?(self)
        animate {
            sender.transform = CGAffineTransform.identity
        }
    }

    @objc private func handleTouchDown(_ sender: UIButton) {
        onTouchDown?(self)
    }

    @objc private func handleTouchUp(_ sender: UIButton) {
        onTouchUp?(self)
    }
}
