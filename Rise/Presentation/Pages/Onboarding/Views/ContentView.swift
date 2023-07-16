//
//  ContentView.swift
//  Rise
//
//  Created by Vladimir Korolev on 11.09.2021.
//  Copyright © 2021 VladimirBrejcha. All rights reserved.
//

import UIKit

extension Onboarding.View {

  final class ContentView: UIView {

    struct Model {
      let title: String
        let image: String
      let description: String
    }
    private var model: Model?

    // MARK: - Subviews

    private lazy var title: UILabel = {
      let label = UILabel()
      label.numberOfLines = 0
      label.applyStyle(.boldBigTitle)
        label.layer.applyStyle(
          .init(shadow: .onboardingShadow)
        )
      label.adjustsFontSizeToFitWidth = true
      label.minimumScaleFactor = 0.7
      return label
    }()

    private lazy var stackView: UIStackView = {
      let stack = UIStackView()
      stack.axis = .vertical
      stack.spacing = 30
      stack.alignment = .fill
      stack.distribution = .equalSpacing
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
        title.attributedText = NSAttributedString(string: model.title, attributes: [
            .strokeColor: Asset.Colors.lightBlue.color.withAlphaComponent(0.5),
            .foregroundColor: UIColor.white,
            .strokeWidth: -1.0
        ])
      addSubviews(
//        title,
        stackView
      )
        let image = UIImageView(image: UIImage.init(systemName: model.image)?.withRenderingMode(.alwaysTemplate))
        image.layer.applyStyle(Style.Layer(shadow: Style.Layer.Shadow(radius: 15, opacity: 0.6, color: Asset.Colors.lightBlue.color.cgColor)))
        image.contentMode = .scaleAspectFit
        image.activateConstraints(
            image.heightAnchor.constraint(equalToConstant: 70)
        )
        image.tintColor = .white

        stackView.addArrangedSubviews(
            image,
            title,
            DescriptionLabel(text: model.description)
        )
    }

    // MARK: - Layout

    private func setupLayout() {
//      title.activateConstraints(
//        title.topAnchor.constraint(equalTo: topAnchor, constant: 44),
//        title.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
//        title.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20)
//      )
      stackView.activateConstraints(
        stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
        stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
        stackView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 32)
//        stackView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -120)
//        stackView.centerYAnchor.constraint(equalTo: centerYAnchor)
//        stackView.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 60)
      )
    }
  }
}
