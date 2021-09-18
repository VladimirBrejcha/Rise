//
//  DaysCollectionCell+SideItemVStack.swift
//  Rise
//
//  Created by Vladimir Korolev on 18.09.2021.
//  Copyright © 2021 VladimirBrejcha. All rights reserved.
//

import UIKit

extension DaysCollectionCell {

    final class SideItemVStack: UIStackView {

        // MARK: - Subviews

        private lazy var topLabel: UILabel = {
            let label = UILabel()
            label.applyStyle(.mediumSizedTitle)
            label.minimumScaleFactor = 0.7
            label.adjustsFontSizeToFitWidth = true
            return label
        }()

        private lazy var imageView: UIImageView = {
            let view = UIImageView()
            view.tintColor = Asset.Colors.white.color
            view.contentMode = .scaleAspectFit
            view.clipsToBounds = true
            return view
        }()

        private lazy var bottomLabel: UILabel = {
            let label = UILabel()
            label.applyStyle(.mediumSizedTitle)
            label.minimumScaleFactor = 0.7
            label.adjustsFontSizeToFitWidth = true
            return label
        }()

        // MARK: - LifeCycle

        init() {
            super.init(frame: .zero)
            setup()
        }

        @available(*, unavailable)
        required init(coder: NSCoder) {
            fatalError("This class does not support NSCoder")
        }

        func configure(topText: String, bottomText: String, image: UIImage) {
            topLabel.text = topText
            bottomLabel.text = bottomText
            imageView.image = image
        }

        private func setup() {
            axis = .vertical
            alignment = .fill
            distribution = .fillEqually
            spacing = 2

            setupViews()
        }

        private func setupViews() {
            addArrangedSubviews(
                topLabel,
                imageView,
                bottomLabel
            )
        }
    }
}
