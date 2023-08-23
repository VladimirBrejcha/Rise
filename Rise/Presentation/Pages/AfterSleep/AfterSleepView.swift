//  
//  AfterSleepView.swift
//  Rise
//
//  Created by Vladimir Korolev on 24.11.2021.
//  Copyright © 2021 VladimirBrejcha. All rights reserved.
//

import UIKit
import Localization
import UIKit
import UILibrary

final class AfterSleepView: UIView {

    private let doneHandler: () -> Void
    private let adjustScheduleHandler: () -> Void

    struct Model {
        let image: UIImage
        let title: String
        let quote: String
        let lines: [(String, String)]
    }
    private let model: Model
    private let showAdjustSchedule: Bool

    // MARK: - Subviews

    private lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()

    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = model.image
        imageView.tintColor = Asset.Colors.white.color
        imageView.contentMode = .scaleAspectFit
        imageView.layer.applyStyle(
            Style.Layer(shadow: Style.Layer.Shadow(
                radius: 15, opacity: 0.6,
                color: Asset.Colors.lightBlue.color.cgColor)
            )
        )
        return imageView
    }()

    private lazy var mainLabel: UILabel = {
        let label = UILabel()
        label.applyStyle(.boldBigTitle)
        label.layer.applyStyle(
            .init(shadow: .onboardingShadow)
        )
        label.numberOfLines = 0
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        label.attributedText = .onTopOfRich(text: model.title)
        return label
    }()

    private lazy var sleepStatsLabel: UILabel = {
        let label = UILabel()
        label.text = "Your sleep"
        label.applyStyle(.onTopOfRich)
        label.layer.applyStyle(
            .init(shadow: .onboardingShadow)
        )
        label.textColor = .white
        return label
    }()

    private lazy var VStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .fillProportionally
        stack.backgroundColor = Asset.Colors.darkBlue.color.withAlphaComponent(0.2)
        stack.layer.cornerRadius = 12
        stack.spacing = 8
        return stack
    }()

    private lazy var quoteView: UIView = {
        let label = UILabel()
        label.applyStyle(.onTopOfRich)
        label.numberOfLines = 0
        label.attributedText = .descriptionOnTopOfRich(text: model.quote)
        let bgView = UIView()
        bgView.backgroundColor = Asset.Colors.darkBlue.color.withAlphaComponent(0.2)
        bgView.layer.cornerRadius = 12
        bgView.addSubview(label)
        label.activateConstraints(edgesTo(bgView, padding: UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)))
        return bgView
    }()

    private func descriptionLabel(text: String, image: String) -> UIView {
        let label = UILabel()
        label.applyStyle(.onTopOfRich)
        label.numberOfLines = 0
        label.attributedText = .descriptionOnTopOfRich(text: text, alignment: .left)

        let hStack = UIStackView()
        hStack.distribution = .fillProportionally
        hStack.axis = .horizontal
        hStack.spacing = 16

        let image = UIImage(systemName: image)?
            .withRenderingMode(.alwaysTemplate)

        let imageView = UIImageView(image: image)
        imageView.tintColor = .white

        hStack.addArrangedSubviews(
            UIView(), imageView, label
        )

        imageView.contentMode = .scaleAspectFit
        imageView.activateConstraints {
            [$0.widthAnchor.constraint(equalToConstant: 26)]
        }

        return hStack
    }

    private lazy var buttonsVStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 8
        return stack
    }()

    private lazy var adjustScheduleButton: Button = {
        let button = Button()
        button.setTitle(Text.adjustSchedule, for: .normal)
        button.applyStyle(.secondary)
        button.onTouchUp = { [weak self] in
            self?.adjustScheduleHandler()
        }
        button.isHidden = !showAdjustSchedule
        return button
    }()

    private lazy var doneButton: Button = {
        let button = Button()
        button.setTitle(Text.AfterSleep.done, for: .normal)
        button.onTouchUp = { [weak self] in
            self?.doneHandler()
        }
        return button
    }()

    // MARK: - LifeCycle

    init(doneHandler: @escaping () -> Void,
         adjustScheduleHandler: @escaping () -> Void,
         model: Model,
         showAdjustSchedule: Bool
    ) {
        self.doneHandler = doneHandler
        self.adjustScheduleHandler = adjustScheduleHandler
        self.model = model
        self.showAdjustSchedule = showAdjustSchedule
        super.init(frame: .zero)
        setupViews()
        setupLayout()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("This class does not support NSCoder")
    }

    private func setupViews() {
        addBackgroundView(.rich)
        addSubviews(
            containerView.addSubviews(
                imageView,
                mainLabel,
                quoteView,
                sleepStatsLabel,
                VStack.addArrangedSubviews(
                   CollectionOfOne(UIView())
                   + model.lines.map(descriptionLabel(text:image:))
                   + CollectionOfOne(UIView())
                )
            ),
            buttonsVStack.addArrangedSubviews(
                adjustScheduleButton,
                doneButton
            )
        )
    }

    func animate(_ animate: Bool) {
        guard animate else {
            imageView.stopAnimating()
            return
        }
        UIView.animate(withDuration: 1,
                       delay: 0,
                       options: [.autoreverse, .repeat, .curveEaseInOut]
        ) { [self] in
            imageView.transform = CGAffineTransform(translationX: 0, y: 12)
        }
    }

    // MARK: - Layout

    private func setupLayout() {
        containerView.activateConstraints {
            [$0.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            $0.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            $0.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 40)]
        }
        imageView.activateConstraints {
            [$0.heightAnchor.constraint(equalToConstant: 100),
            $0.widthAnchor.constraint(equalToConstant: 100),
            $0.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            $0.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 20)]
        }
        mainLabel.activateConstraints {
            [$0.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 8),
            $0.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -8),
            $0.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 30)]
        }
        quoteView.activateConstraints {
            [$0.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 8),
            $0.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -8),
            $0.topAnchor.constraint(equalTo: mainLabel.bottomAnchor, constant: 28)]
        }
        sleepStatsLabel.activateConstraints {
            [$0.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            $0.topAnchor.constraint(equalTo: quoteView.bottomAnchor, constant: 28)]
        }
        VStack.activateConstraints {
            [$0.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 8),
            $0.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -8),
            $0.topAnchor.constraint(equalTo: sleepStatsLabel.bottomAnchor, constant: 4),
            $0.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: 0)]
        }
        buttonsVStack.activateConstraints {
            [$0.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 40),
            $0.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -40),
            $0.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -30)]
        }
        buttonsVStack.subviews.forEach { view in
            view.activateConstraints {
                [$0.heightAnchor.constraint(equalToConstant: 44)]
            }
        }
    }
}
