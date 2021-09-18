//
//  SelectableStackViewButton.swift
//  Rise
//
//  Created by Vladimir Korolev on 09.12.2019.
//  Copyright © 2019-2020 VladimirBrejcha. All rights reserved.
//

import UIKit
import SelectableStackView

final class SelectableStackViewButton: UIButton, StyledButton, ObservableBySelectableStackView {

    var style: Style.Button = .init(
        selectedTitleColor: Asset.Colors.white.color,
        titleStyle: .init(
            font: UIFont.systemFont(ofSize: 13),
            color: Asset.Colors.white.color.withAlphaComponent(0.5),
            alignment: .center
        ),
        backgroundColor: .clear
    )
    var observer: ((ObservableBySelectableStackView) -> Void)?
    var handlingSelfSelection: Bool = false

    convenience init(title: String) {
        self.init(frame: .zero)
        self.applyStyle(style)
        self.setTitle(title, for: .normal)
        addTarget(self, action: #selector(touchUpInside), for: .touchUpInside)
    }

    @objc private func touchUpInside() {
        observer?(self)
    }
}
