//
//  UIStackView+addArrangedSubviews.swift
//  Rise
//
//  Created by Vladimir Korolev on 12.09.2021.
//  Copyright © 2021 VladimirBrejcha. All rights reserved.
//

import UIKit

extension UIStackView {
    @discardableResult func addArrangedSubviews(
        _ subviews: UIView...,
        separated: Bool = false,
        separatorColor: UIColor = Asset.Colors.whiteSeparator.color
    ) -> Self {
        addArrangedSubviews(subviews, separated: separated, separatorColor: separatorColor)
    }

    @discardableResult func addArrangedSubviews(
        _ subviews: [UIView],
        separated: Bool = false,
        separatorColor: UIColor = Asset.Colors.whiteSeparator.color
    ) -> Self {
        subviews.forEach { addArrangedSubview($0) }
        if separated { addSeparators(color: separatorColor) }
        return self
    }
}
