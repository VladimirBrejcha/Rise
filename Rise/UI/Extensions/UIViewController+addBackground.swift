//
//  UIViewController+addBackground.swift
//  Rise
//
//  Created by Vladimir Korolev on 21.11.2021.
//  Copyright © 2021 VladimirBrejcha. All rights reserved.
//

import UIKit

extension UIView {
    func addBackgroundView(
        _ bgView: View.Background = .default,
        blur: UIBlurEffect.Style? = nil
    ) {
        let view = bgView.asUIView
        blur.flatMap(view.applyBlur(style:))
        addSubview(view)
        sendSubviewToBack(view)
        view.clipsToBounds = true
        view.activateConstraints(
            view.leadingAnchor.constraint(equalTo: leadingAnchor),
            view.trailingAnchor.constraint(equalTo: trailingAnchor),
            view.topAnchor.constraint(equalTo: topAnchor),
            view.bottomAnchor.constraint(equalTo: bottomAnchor)
        )
    }
}
