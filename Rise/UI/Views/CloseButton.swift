//
//  CloseButton.swift
//  Rise
//
//  Created by Vladimir Korolev on 21.11.2021.
//  Copyright © 2021 VladimirBrejcha. All rights reserved.
//

extension View {
    static func closeButton(handler: @escaping () -> Void) -> Button {
        let closeButton = Button()
        closeButton.applyStyle(.image)
        closeButton.setImage(Asset.cancel.image, for: .normal)
        closeButton.tintColor = Asset.Colors.white.color
        closeButton.onTouchUp = { handler() }
        return closeButton
    }
}
