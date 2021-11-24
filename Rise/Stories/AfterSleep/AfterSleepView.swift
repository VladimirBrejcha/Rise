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

    // MARK: - Subviews

    private lazy var titleView: UIView = View.Title.make(
        title: appearance.titleText,
        closeButton: .none
    )

    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: appearance.imageName)
        imageView.tintColor = Asset.Colors.white.color
        return imageView
    }()

    private lazy var doneButton: Button = {
        let button = Button()
        button.setTitle(Text.AfterSleep.done, for: .normal)
        button.onTouchUp = { [weak self] _ in
            self?.doneHandler()
        }
        return button
    }()

    // MARK: - LifeCycle

    init(
        doneHandler: @escaping () -> Void,
        appearance: Appearance
    ) {
        self.doneHandler = doneHandler
        self.appearance = appearance
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
            imageView,
            doneButton
        )
    }

    // MARK: - Layout

    private func setupLayout() {
        imageView.activateConstraints(
            imageView.heightAnchor.constraint(equalToConstant: appearance.imageSideSize),
            imageView.widthAnchor.constraint(equalToConstant: appearance.imageSideSize),
            imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            imageView.topAnchor.constraint(equalTo: titleView.bottomAnchor, constant: 40)
        )
        doneButton.activateConstraints(
            doneButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            doneButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            doneButton.heightAnchor.constraint(equalToConstant: 50),
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
