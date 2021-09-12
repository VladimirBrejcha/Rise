//
//  AboutItemView.swift
//  Rise
//
//  Created by Vladimir Korolev on 12.09.2021.
//  Copyright © 2021 VladimirBrejcha. All rights reserved.
//

import UIKit

extension AboutView {

    final class ItemView: UIView, PropertyAnimatable {

        struct Model {
            let identifier: AboutIdentifier
            let text: String
        }
        private var model: Model!
        private var touchHandler: (() -> Void)?
        var propertyAnimationDuration: Double { 0.2 }

        // MARK: - Subviews

        private lazy var titleLabel: UILabel = {
            let label = UILabel()
            label.numberOfLines = 1
            label.applyStyle(.mediumSizedBody)
            label.adjustsFontSizeToFitWidth = true
            label.minimumScaleFactor = 0.7
            return label
        }()

        // MARK: - LifeCycle

        convenience init(model: Model, touchHandler: @escaping () -> Void) {
            self.init(frame: .zero)
            self.model = model
            self.touchHandler = touchHandler
            setup()
        }

        private func setup() {
            setupViews()
            setupLayout()
        }

        private func setupViews() {
            addSubviews(
                titleLabel
            )
            titleLabel.text = model.text
        }

        override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
            super.touchesBegan(touches, with: event)
            drawSelection(true)
        }

        override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
            super.touchesEnded(touches, with: event)
            drawSelection(false)
            if let touch = touches.first {
                if point(
                    inside: touch.location(in: self),
                    with: event
                ) {
                    touchHandler?()
                }
            }
        }

        func drawSelection(_ draw: Bool) {
            animate {
                self.backgroundColor = draw ? .white.withAlphaComponent(0.3) : .clear
            }
        }

        // MARK: - Layout

        private func setupLayout() {
            titleLabel.activateConstraints(
                titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 12),
                titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
                titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
                titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12)
            )
        }
    }
}
