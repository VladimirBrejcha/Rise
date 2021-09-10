//
//  BorderedView.swift
//  Rise
//
//  Created by Vladimir Korolev on 20.02.2021.
//  Copyright © 2021 VladimirBrejcha. All rights reserved.
//

import UIKit

final class BorderedView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configure()
    }

    private func configure() {
        backgroundColor = .clear
        layer.borderColor = UIColor.white.withAlphaComponent(0.85).cgColor
        layer.borderWidth = 1
        layer.cornerRadius = 15
    }
}
