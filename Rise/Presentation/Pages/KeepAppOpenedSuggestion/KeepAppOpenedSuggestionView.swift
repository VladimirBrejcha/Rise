//  
//  KeepAppOpenedSuggestionView.swift
//  Rise
//
//  Created by Vladimir Korolev on 23.11.2021.
//  Copyright © 2021 VladimirBrejcha. All rights reserved.
//

import UIKit
import Localization
import UILibrary

extension KeepAppOpenedSuggestion {

  final class View: UIView {

    private let continueHandler: () -> Void

    // MARK: - Subviews

    private lazy var titleView: UIView = Title.make(
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
      button.onTouchUp = { [weak self] in
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
        imageView.activateConstraints {
            [$0.heightAnchor.constraint(equalToConstant: 60),
            $0.widthAnchor.constraint(equalToConstant: 60),
            $0.centerXAnchor.constraint(equalTo: centerXAnchor),
            $0.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -100)]
        }
        descriptionLabel.activateConstraints {
            [$0.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20),
            $0.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            $0.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20)]
        }
        continueButton.activateConstraints {
            [$0.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 40),
            $0.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -40),
            $0.heightAnchor.constraint(equalToConstant: 44),
            $0.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -20)]
        }
    }
  }
}
