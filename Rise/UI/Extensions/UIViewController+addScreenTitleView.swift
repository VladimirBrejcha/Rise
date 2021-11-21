//
//  UIViewController+addTitleView.swift
//  Rise
//
//  Created by Vladimir Korolev on 21.11.2021.
//  Copyright © 2021 VladimirBrejcha. All rights reserved.
//

import UIKit

extension UIView {
    func addScreenTitleView(_ titleView: UIView) {
        addSubview(titleView)
        titleView.activateConstraints(
            titleView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            titleView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            titleView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor)
        )
    }
}
