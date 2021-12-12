//  
//  KeepAppOpenedSuggestionView.swift
//  Rise
//
//  Created by Vladimir Korolev on 23.11.2021.
//  Copyright © 2021 VladimirBrejcha. All rights reserved.
//

import UIKit

final class KeepAppOpenedSuggestionView: UIView {

    private let continueHandler: () -> Void

    // MARK: - Subviews

    private lazy var titleView: UIView = View.Title.make(
        title: Text.KeepAppOpenedSuggestion.title,
        closeButton: .none
    )

    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "app.badge.checkmark")
        imageView.contentMode = .scaleAspectFill
        imageView.tintColor = Asset.Colors.white.color
        return imageView
    }()

    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.applyStyle(.mediumSizedBody)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.text = """
                     \(Text.KeepAppOpenedSuggestion.description)

                     \(Text.KeepAppOpenedSuggestion.whereToPlacePhone)

                     \(Text.KeepAppOpenedSuggestion.descriptionWhy)
                     """
        return label
    }()

    private lazy var continueButton: Button = {
        let button = Button()
        button.setTitle(Text.KeepAppOpenedSuggestion.continue, for: .normal)
        button.onTouchUp = { [weak self] _ in
            self?.continueHandler()
        }
        return button
    }()

    // MARK: - LifeCycle

    init(continueHandler: @escaping () -> Void) {
        self.continueHandler = continueHandler
        super.init(frame: .zero)
        setupViews()
        setupLayout()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("This class does not support NSCoder")
    }

    private func setupViews() {
        addBackgroundView(.rich, blur: .dark)
        addScreenTitleView(titleView)
        addSubviews(
            imageView,
            descriptionLabel,
            continueButton
        )
    }

    // MARK: - Layout

    private func setupLayout() {
        imageView.activateConstraints(
            imageView.heightAnchor.constraint(equalToConstant: 60),
            imageView.widthAnchor.constraint(equalToConstant: 60),
            imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -100)
        )
        descriptionLabel.activateConstraints(
            descriptionLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20),
            descriptionLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            descriptionLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20)
        )
        continueButton.activateConstraints(
            continueButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 40),
            continueButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -40),
            continueButton.heightAnchor.constraint(equalToConstant: 44),
            continueButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -10)
        )
    }
}
