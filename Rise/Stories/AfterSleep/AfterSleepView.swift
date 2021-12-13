//  
//  AfterSleepView.swift
//  Rise
//
//  Created by Vladimir Korolev on 24.11.2021.
//  Copyright © 2021 VladimirBrejcha. All rights reserved.
//

import UIKit

final class AfterSleepView: UIView {

    private let doneHandler: () -> Void
    private let appearance: Appearance
    private let wentSleepTime: String
    private let wokeUpTime: String
    private let totalSleepTime: String?

    // MARK: - Subviews

    private lazy var titleView: UIView = View.Title.make(
        title: appearance.titleText,
        closeButton: .none
    )

    private lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()

    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: appearance.imageName)
        imageView.tintColor = Asset.Colors.white.color
        imageView.layer.applyStyle(
            .init(
                shadow: .whiteBgSeparatorSmall
            )
        )
        return imageView
    }()

    private lazy var mainLabel: UILabel = {
        let label = UILabel()
        label.applyStyle(.boldBigTitle)
        label.text = Text.AfterSleep.mainText
        label.layer.applyStyle(
            .init(shadow: .whiteBgSeparatorSmall)
        )
        return label
    }()

    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.applyStyle(.mediumSizedBody)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.text = """
                     You went to sleep at \(wentSleepTime)
                     and woke up at \(wokeUpTime)
                     \(totalSleepTime == nil ? "" : "total \(totalSleepTime!) of sleep")
                     """
        label.layer.applyStyle(
            .init(shadow: .whiteBgSeparatorBig)
        )
        return label
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

    init(
        doneHandler: @escaping () -> Void,
        appearance: Appearance,
        wentSleepTime: String,
        wokeUpTime: String,
        totalSleepTime: String?
    ) {
        self.doneHandler = doneHandler
        self.appearance = appearance
        self.wentSleepTime = wentSleepTime
        self.wokeUpTime = wokeUpTime
        self.totalSleepTime = totalSleepTime
        super.init(frame: .zero)
        setupViews()
        setupLayout()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("This class does not support NSCoder")
    }

    private func setupViews() {
        addBackgroundView(.rich, blur: .light)
        addScreenTitleView(titleView)
        addSubviews(
            containerView.addSubviews(
                imageView,
                mainLabel,
                descriptionLabel
            ),
            doneButton
        )
    }

    // MARK: - Layout

    private func setupLayout() {
        containerView.activateConstraints(
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            containerView.centerYAnchor.constraint(equalTo: centerYAnchor)
        )
        imageView.activateConstraints(
            imageView.heightAnchor.constraint(equalToConstant: appearance.imageSideSize),
            imageView.widthAnchor.constraint(equalToConstant: appearance.imageSideSize),
            imageView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            imageView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 20)
        )
        mainLabel.activateConstraints(
            mainLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 8),
            mainLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -8),
            mainLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 30)
        )
        descriptionLabel.activateConstraints(
            descriptionLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 8),
            descriptionLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -8),
            descriptionLabel.topAnchor.constraint(equalTo: mainLabel.bottomAnchor, constant: 20),
            descriptionLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -20)
        )
        doneButton.activateConstraints(
            doneButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 40),
            doneButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -40),
            doneButton.heightAnchor.constraint(equalToConstant: 44),
            doneButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -30)
        )
    }
}

extension AfterSleepView {
    enum Appearance {
        case sleepStopped
        case sleepFinished
    }
}

fileprivate extension AfterSleepView.Appearance {
    var titleText: String {
        switch self {
        case .sleepFinished:
            return Text.AfterSleep.title
        case .sleepStopped:
            return Text.AfterSleep.titleSleepStopped
        }
    }

    var imageName: String {
        switch self {
        case .sleepFinished:
            return "sun.max.fill"
        case .sleepStopped:
            return "alarm"
        }
    }

    var imageSideSize: CGFloat {
        switch self {
        case .sleepFinished:
            return 100
        case .sleepStopped:
            return 80
        }
    }
}
