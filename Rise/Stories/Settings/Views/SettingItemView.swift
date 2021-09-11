//
//  SettingItemView.swift
//  Rise
//
//  Created by Vladimir Korolev on 12.09.2021.
//  Copyright © 2021 VladimirBrejcha. All rights reserved.
//

import UIKit

extension SettingsView {

    final class SettingItemView: UIView, PropertyAnimatable {

        struct Model {
            let identifier: SettingIdentifier
            let image: UIImage
            let title: String
            let description: String
        }
        private var model: Model!
        private var touchHandler: (() -> Void)?
        var propertyAnimationDuration: Double { 0.2 }

        // MARK: - Subviewss

        private lazy var imageView: UIImageView = {
            let view = UIImageView()
            view.contentMode = .scaleAspectFit
            view.tintColor = .white
            view.clipsToBounds = true
            return view
        }()

        private lazy var titleLabel: UILabel = {
            let label = UILabel()
            label.applyStyle(.mediumSizedBody)
            label.minimumScaleFactor = 0.7
            label.adjustsFontSizeToFitWidth = true
            label.numberOfLines = 1
            return label
        }()

        private lazy var descriptionLabel: UILabel = {
            let label = UILabel()
            label.applyStyle(.description)
            label.minimumScaleFactor = 0.7
            label.adjustsFontSizeToFitWidth = true
            label.numberOfLines = 1
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
                imageView,
                titleLabel,
                descriptionLabel
            )
            imageView.image = model.image
            titleLabel.text = model.title
            descriptionLabel.text = model.description
        }

        override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
            super.touchesBegan(touches, with: event)
            drawSelection(true)
            touchHandler?()
        }

        override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
            super.touchesEnded(touches, with: event)
            drawSelection(false)
        }

        func drawSelection(_ draw: Bool) {
            animate {
                self.backgroundColor = draw ? .white.withAlphaComponent(0.3) : .clear
            }
        }

        // MARK: - Layout

        private func setupLayout() {
            imageView.activateConstraints(
                imageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
                imageView.heightAnchor.constraint(equalToConstant: 28),
                imageView.widthAnchor.constraint(equalToConstant: 28),
                imageView.centerYAnchor.constraint(equalTo: centerYAnchor)
            )
            titleLabel.activateConstraints(
                titleLabel.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 8),
                titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 8),
                titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 8)
            )
            descriptionLabel.activateConstraints(
                descriptionLabel.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 8),
                descriptionLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
                descriptionLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
                descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4)
            )
        }
    }
}
