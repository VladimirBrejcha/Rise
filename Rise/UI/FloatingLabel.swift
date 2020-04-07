//
//  FloatingLabel.swift
//  Rise
//
//  Created by Владимир Королев on 16.02.2020.
//  Copyright © 2020 VladimirBrejcha. All rights reserved.
//

import UIKit

struct FloatingLabelModel {
    let text: String
    let alpha: Float
}

final class FloatingLabel: UILabel, AutoRefreshable, PropertyAnimatable {
    typealias DataSource = () -> FloatingLabelModel
    var dataSource: DataSource?
    var refreshInterval: Double = 2
    var propertyAnimationDuration: Double = 1
    
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
    
    private func sharedInit() {
        beginRefreshing()
        initialDraw = {
            self.animation.add(on: self.layer)
        }
    }
    
    deinit {
        animation.removeFromSuperlayer()
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        initialDraw?()
        initialDraw = nil
    }
    
    func refresh(_ dataSource: DataSource?) {
        if let data = dataSource?() {
            self.text = data.text
            animate {
                self.alpha = CGFloat(data.alpha)
            }
        }
    }
}
