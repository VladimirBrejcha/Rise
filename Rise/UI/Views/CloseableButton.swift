//
//  CloseableButton.swift
//  Rise
//
//  Created by Vladimir Korolev on 21.11.2021.
//  Copyright © 2021 VladimirBrejcha. All rights reserved.
//

func closeableButton(closeHandler: @escaping () -> Void) -> Button {
    let button = Button()
    let closeButton = makeCloseButton(handler: closeHandler)
    button.addSubview(closeButton)
    closeButton.activateConstraints(
        closeButton.trailingAnchor.constraint(equalTo: button.trailingAnchor, constant: -6),
        closeButton.centerYAnchor.constraint(equalTo: button.centerYAnchor),
        closeButton.widthAnchor.constraint(equalToConstant: 40),
        closeButton.heightAnchor.constraint(equalToConstant: 40)
    )
    return button
}
