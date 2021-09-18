//
//  FloatingLabel.swift
//  Rise
//
//  Created by Vladimir Korolev on 16.02.2020.
//  Copyright © 2020 VladimirBrejcha. All rights reserved.
//

import UIKit

final class FloatingLabel: UILabel, AutoRefreshable, PropertyAnimatable {

    private let animation = VerticalPositionMoveAnimation()
    var propertyAnimationDuration: Double = 1
    private var needsConfiguration: Bool = true

    override func layoutSubviews() {
        super.layoutSubviews()
        if needsConfiguration {
            animation.add(to: layer)
            needsConfiguration = false
        }
    }

    deinit {
        animation.removeFromSuperlayer()
        stopRefreshing()
    }

    // MARK: - AutoRefreshable

    var timer: Timer?
    var refreshInterval: Double = 2
    var dataSource: (() -> Model)?

    struct Model {
        let text: String
        let alpha: Float
    }
    
    func refresh(with data: Model) {
        text = data.text
        animate {
            self.alpha = CGFloat(data.alpha)
        }
    }
}
