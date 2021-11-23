//
//  ScreenTitleView.swift
//  Rise
//
//  Created by Vladimir Korolev on 21.11.2021.
//  Copyright © 2021 VladimirBrejcha. All rights reserved.
//

import UIKit

extension View {

    enum Title {

        enum CloseButton {
            case none
            case `default`(handler: () -> Void)
        }

        static func make(
            title: String,
            closeButton: CloseButton
        ) -> UIView {
            let view = UIView()
            view.backgroundColor = .clear

            let titleLabel: UILabel = {
                let label = UILabel()
                label.applyStyle(.mediumSizedTitle)
                label.text = title
                return label
            }()

            view.activateConstraints(
                view.heightAnchor.constraint(equalToConstant: 45)
            )

            view.addSubview(titleLabel)
            titleLabel.activateConstraints(
                titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
                titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
                titleLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 5)
            )

            if case let .default(handler) = closeButton {
                let closeButton: Button = View.closeButton(
                    handler: handler
                )
                view.addSubview(closeButton)
                closeButton.activateConstraints(
                    closeButton.widthAnchor.constraint(equalToConstant: 35),
                    closeButton.heightAnchor.constraint(equalToConstant: 35),
                    closeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
                    closeButton.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 5)
                )
            }

            return view
        }
    }
}
