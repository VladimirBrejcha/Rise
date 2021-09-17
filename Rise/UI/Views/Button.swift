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

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configure()
    }
    
    private func configure() {
        applyStyle(.primary)
        addTarget(self, action: #selector(scaleDown(_:)), for: [.touchDown, .touchDragInside])
        addTarget(self, action: #selector(scaleUp(_:)), for: [.touchUpInside, .touchDragOutside, .touchCancel])
        addTarget(self, action: #selector(handleTouchDown(_:)), for: [.touchDown])
        addTarget(self, action: #selector(handleTouchUp(_:)), for: [.touchUpInside])
    }
    
    @objc private func scaleDown(_ sender: UIButton) {
        animate { [weak self] in
            if let self = self {
                sender.transform = self.style.scaleTransform
            }
        }
    }
    
    @objc private func scaleUp(_ sender: UIButton) {
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
