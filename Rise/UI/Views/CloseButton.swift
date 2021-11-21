//
//  CloseButton.swift
//  Rise
//
//  Created by Vladimir Korolev on 21.11.2021.
//  Copyright © 2021 VladimirBrejcha. All rights reserved.
//

func makeCloseButton(handler: @escaping () -> Void) -> Button {
    let closeButton = Button()
    closeButton.applyStyle(.image)
    closeButton.setImage(Asset.cancel.image, for: .normal)
    closeButton.tintColor = Asset.Colors.white.color
    closeButton.onTouchUp = { _ in
        handler()
    }
    return closeButton
}
