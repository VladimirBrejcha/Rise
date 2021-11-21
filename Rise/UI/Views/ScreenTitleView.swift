//
//  ScreenTitleView.swift
//  Rise
//
//  Created by Vladimir Korolev on 21.11.2021.
//  Copyright © 2021 VladimirBrejcha. All rights reserved.
//

import UIKit

extension View {
    static func screenTitleView(
        title: String,
        closeHandler: @escaping () -> Void
    ) -> UIView {

        let view = UIView()
        view.backgroundColor = .clear

        let titleLabel: UILabel = {
            let label = UILabel()
            label.applyStyle(.mediumSizedTitle)
            label.text = title
            return label
        }()

        let closeButton: Button = View.closeButton(
            handler: closeHandler
        )

        view.addSubviews(
            titleLabel,
            closeButton
        )

        view.activateConstraints(
            view.heightAnchor.constraint(equalToConstant: 45)
        )

        titleLabel.activateConstraints(
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            titleLabel.centerYAnchor.constraint(equalTo: closeButton.centerYAnchor)
        )
        closeButton.activateConstraints(
            closeButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 10),
            closeButton.widthAnchor.constraint(equalToConstant: 35),
            closeButton.heightAnchor.constraint(equalToConstant: 35),
            closeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10)
        )

        return view
    }
}
