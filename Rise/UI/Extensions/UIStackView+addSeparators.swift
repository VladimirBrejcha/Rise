//
//  UIStackView+addSeparators.swift
//  Rise
//
//  Created by Vladimir Korolev on 12.09.2021.
//  Copyright © 2021 VladimirBrejcha. All rights reserved.
//

import UIKit

extension UIStackView {
    func addSeparators(color: UIColor) {
        var i = arrangedSubviews.count - 1
        while i > 0 {
            let separator = createSeparator(color: color)
            insertArrangedSubview(separator, at: i)
            i -= 1
        }
    }

    private func createSeparator(color: UIColor) -> UIView {
        let separator = UIView()
        separator.activateConstraints(
            {
                if axis == .vertical {
                    return separator.heightAnchor.constraint(equalToConstant: 1)
                } else {
                    return separator.widthAnchor.constraint(equalToConstant: 1)
                }
            }()
        )
        separator.backgroundColor = color
        return separator
    }
}
