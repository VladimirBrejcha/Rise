//
//  FloatingButton.swift
//  Rise
//
//  Created by Владимир Королев on 13.08.2020.
//  Copyright © 2020 VladimirBrejcha. All rights reserved.
//

import UIKit

final class FloatingButton: Button {
    private var initialDraw: (() -> Void)?
    private let animation = VerticalPositionMoveAnimation()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        sharedInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        sharedInit()
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        initialDraw?()
        initialDraw = nil
    }
    
    private func sharedInit() {
        initialDraw = {
            self.animation.add(on: self.layer)
        }
    }
    
    deinit {
        animation.removeFromSuperlayer()
    }
}
