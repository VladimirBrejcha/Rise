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
        backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.07)
        layer.cornerRadius = 12
        addTarget(self, action: #selector(backToNormalSize(_:)), for: .touchCancel)
        addTarget(self, action: #selector(backToNormalSize(_:)), for: .touchDragOutside)
        addTarget(self, action: #selector(backToNormalSize(_:)), for: .touchUpInside)
        addTarget(self, action: #selector(decreaseButtonSize(_:)), for: .touchDown)
        addTarget(self, action: #selector(decreaseButtonSize(_:)), for: .touchDragInside)
    }
    
    @objc func decreaseButtonSize(_ sender: UIButton) {
        UIView.animate(withDuration: 0.1, animations: { sender.transform = CGAffineTransform(scaleX: 0.93, y: 0.93) })
    }
    
    @objc func backToNormalSize(_ sender: UIButton) {
        UIView.animate(withDuration: 0.1) { sender.transform = CGAffineTransform.identity }
    }

}
