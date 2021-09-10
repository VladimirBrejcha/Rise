//
//  ErrorViewRemovable.swift
//  Rise
//
//  Created by Vladimir Korolev on 18.08.2020.
//  Copyright © 2020 VladimirBrejcha. All rights reserved.
//

import UIKit

protocol ErrorViewRemovable {
    var errorViewSuperview: UIView { get }

    func removeErrorView()
}

extension ErrorViewRemovable {
    func removeErrorView() {
        errorViewSuperview.subviews
            .filter { $0 is ErrorView }
            .forEach { $0.removeFromSuperview() }
    }
}
