//
//  SettingItemView.swift
//  Rise
//
//  Created by Vladimir Korolev on 12.09.2021.
//  Copyright © 2021 VladimirBrejcha. All rights reserved.
//

import UIKit
import UILibrary

extension Settings.View {

    final class ItemView: UIView, PropertyAnimatable {

        struct Model {
            let setting: Settings.Setting
            let image: UIImage
            let title: String
            let description: String
        }
        let model: Model
        private let touchHandler: () -> Void

        var propertyAnimationDuration: Double { 0.2 }

        // MARK: - Subviews

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

        @available(*, unavailable)
        required init?(coder: NSCoder) {
            fatalError("This class does not support NSCoder")
        }

        init(model: Model, touchHandler: @escaping () -> Void) {
            self.model = model
            self.touchHandler = touchHandler
            super.init(frame: .zero)
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
        }

        override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
            super.touchesEnded(touches, with: event)
            drawSelection(false)
            if let touch = touches.first {
                if point(
                    inside: touch.location(in: self),
                    with: event
                ) {
                    touchHandler()
                }
            }
        }

        func drawSelection(_ draw: Bool) {
            animate { [self] in
                backgroundColor = draw ? .white.withAlphaComponent(0.3) : .clear
            }
        }

        // MARK: - Layout

        private func setupLayout() {
            imageView.activateConstraints {
                [$0.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
                 $0.heightAnchor.constraint(equalToConstant: 28),
                 $0.widthAnchor.constraint(equalToConstant: 28),
                 $0.centerYAnchor.constraint(equalTo: centerYAnchor)]
            }
            titleLabel.activateConstraints {
                [$0.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 8),
                 $0.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 8),
                 $0.topAnchor.constraint(equalTo: topAnchor, constant: 8)]
            }
            descriptionLabel.activateConstraints {
                [$0.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 8),
                 $0.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
                 $0.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
                 $0.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4)]
            }
        }
    }
}
