//
//  ContentView.swift
//  Rise
//
//  Created by Vladimir Korolev on 11.09.2021.
//  Copyright © 2021 VladimirBrejcha. All rights reserved.
//

import UIKit

extension OnboardingView {

    final class ContentView: UIView {

        struct Model {
            let title: String
            let descriptions: [String]
        }
        private var model: Model?

        // MARK: - Subviews

        private lazy var title: UILabel = {
            let label = UILabel()
            label.numberOfLines = 1
            label.applyStyle(.boldBigTitle)
            label.adjustsFontSizeToFitWidth = true
            label.minimumScaleFactor = 0.7
            return label
        }()

        private lazy var stackView: UIStackView = {
            let stack = UIStackView()
            stack.axis = .vertical
            stack.spacing = 24
            stack.alignment = .fill
            stack.distribution = .fill
            return stack
        }()

        // MARK: - LifeCycle

        convenience init(model: Model) {
            self.init(frame: .zero)
            self.model = model
            setup()
        }

        private func setup() {
            setupViews()
            setupLayout()
        }

        private func setupViews() {
            guard let model = model else {
                assertionFailure()
                return
            }
            title.text = model.title
            addSubviews(
                title,
                stackView
            )
            model.descriptions.forEach {
                stackView.addArrangedSubview(
                    DescriptionLabel(text: $0)
                )
            }
        }

        // MARK: - Layout

        private func setupLayout() {
            title.activateConstraints(
                title.topAnchor.constraint(equalTo: topAnchor, constant: 44),
                title.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
                title.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20)
            )
            stackView.activateConstraints(
                stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 32),
                stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -32),
                stackView.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 60)
            )
        }
    }
}
