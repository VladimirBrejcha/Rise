//
//  HorizontalFadeView.swift
//  Rise
//
//  Created by Vladimir Korolev on 04.04.2021.
//  Copyright © 2021 VladimirBrejcha. All rights reserved.
//

import UIKit

final class HorizontalFadeView: UIView {
    private lazy var gradientLayer: CAGradientLayer = {
        let layer = CAGradientLayer()
        layer.apply(
            Gradient(
                position: (
                    start: CGPoint(x: 0, y: 0),
                    end: CGPoint(x: 1, y: 0)
                ),
                colors: Asset.Colors.white.color
                    .colorsUsingAlpha(0, 0.2, 0.2, 0)
                    .map(\.cgColor)
            )
        )
        self.layer.addSublayer(layer)
        return layer
    }()

    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
    }
}

fileprivate extension UIColor {
    func colorsUsingAlpha(_ alpha: CGFloat...) -> [UIColor] {
        alpha.map(withAlphaComponent)
    }
}
