//
//  CloseableButton.swift
//  Rise
//
//  Created by Vladimir Korolev on 21.11.2021.
//  Copyright © 2021 VladimirBrejcha. All rights reserved.
//

extension View {
    static func closeableButton(
        touchHandler: @escaping () -> Void,
        closeHandler: @escaping () -> Void,
        style: Style.Button? = nil
    ) -> Button {
        let button = Button()
        if let style = style { button.applyStyle(style) }
        button.onTouchUp = { _ in touchHandler() }
        let closeButton = View.closeButton(handler: closeHandler)
        button.addSubview(closeButton)
        closeButton.activateConstraints(
            closeButton.trailingAnchor.constraint(equalTo: button.trailingAnchor, constant: -6),
            closeButton.centerYAnchor.constraint(equalTo: button.centerYAnchor),
            closeButton.widthAnchor.constraint(equalToConstant: 40),
            closeButton.heightAnchor.constraint(equalToConstant: 40)
        )
        return button
    }
}
