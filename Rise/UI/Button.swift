//
//  Button.swift
//  Rise
//
//  Created by Владимир Королев on 10.10.2019.
//  Copyright © 2019 VladimirBrejcha. All rights reserved.
//

import UIKit

extension UIButton: Selectable { }

class TouchObservableButton: UIButton, TouchObservable {
    var touchDownObserver: ((TouchObservableButton) -> Void)?
    var touchUpObserver: ((TouchObservableButton) -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        sharedInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        sharedInit()
    }
    
    private func sharedInit() {
        addTarget(self, action: #selector(touchDown(_:)), for: [.touchDown,
                                                                .touchDragInside])
        addTarget(self, action: #selector(touchUp(_:)), for: [.touchDragOutside,
                                                              .touchCancel,
                                                              .touchUpInside,
                                                              .touchUpOutside])
    }
    
    @objc func touchDown(_ sender: UIButton) {
        touchDownObserver?(self)
    }
    
    @objc func touchUp(_ sender: UIButton) {
        touchUpObserver?(self)
    }
}


@IBDesignable
final class Button: TouchObservableButton, PropertyAnimatable {
    typealias Control = Button
    var propertyAnimationDuration: Double = 0.1

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
    }
    
    @objc override func touchDown(_ sender: UIButton) {
        super.touchDown(self)
        animate {
            sender.transform = CGAffineTransform(scaleX: 0.93, y: 0.93)
        }
    }
    
    @objc override func touchUp(_ sender: UIButton) {
        super.touchUp(self)
        animate {
            sender.transform = CGAffineTransform.identity
        }
    }
}
