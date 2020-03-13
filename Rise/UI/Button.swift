//
//  Button.swift
//  Rise
//
//  Created by Владимир Королев on 10.10.2019.
//  Copyright © 2019 VladimirBrejcha. All rights reserved.
//

import UIKit

@IBDesignable
class Button: UIButton {

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
        addTarget(self, action: #selector(backToNormalSize(_:)), for: [.touchDragOutside,
                                                                       .touchCancel,
                                                                       .touchUpInside,
                                                                       .touchUpOutside])
        addTarget(self, action: #selector(decreaseButtonSize(_:)), for: [.touchDown,
                                                                         .touchDragInside])
    }
    
    @objc func decreaseButtonSize(_ sender: UIButton) {
        UIView.animate(withDuration: 0.1, animations: {
            sender.transform = CGAffineTransform(scaleX: 0.93, y: 0.93)
        })
    }
    
    @objc func backToNormalSize(_ sender: UIButton) {
        UIView.animate(withDuration: 0.1) {
            sender.transform = CGAffineTransform.identity
        }
    }
}
