//
//  FloatingLabel.swift
//  Rise
//
//  Created by Vladimir Korolev on 16.02.2020.
//  Copyright © 2020 VladimirBrejcha. All rights reserved.
//

import UIKit

final class FloatingLabel: UILabel, AutoRefreshable, PropertyAnimatable {
    struct Model {
        let text: String
        let alpha: Float
    }
    private var initialDraw: (() -> Void)?
    var propertyAnimationDuration: Double = 1
    private let animation = VerticalPositionMoveAnimation()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        sharedInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        sharedInit()
    }
    
    private func sharedInit() {
        initialDraw = {
            self.animation.add(on: self.layer)
        }
    }
    
    deinit {
        animation.removeFromSuperlayer()
        stopRefreshing()
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        initialDraw?()
        initialDraw = nil
    }
    
    // MARK: - AutoRefreshable -
    var timer: Timer?
    var refreshInterval: Double = 2
    var dataSource: (() -> Model)?
    
    func refresh(with data: Model) {
        text = data.text
        animate { [weak self] in
            self?.alpha = CGFloat(data.alpha)
        }
    }
}
