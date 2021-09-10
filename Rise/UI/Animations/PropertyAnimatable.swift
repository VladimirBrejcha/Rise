//
//  PropertyAnimatable.swift
//  Rise
//
//  Created by Vladimir Korolev on 05.04.2020.
//  Copyright © 2020 VladimirBrejcha. All rights reserved.
//

import UIKit

protocol PropertyAnimatable {
    var propertyAnimationDuration: Double { get }
}

extension PropertyAnimatable {
    func animate(_ animation: @escaping () -> Void) {
        UIViewPropertyAnimator(
            duration: propertyAnimationDuration,
            curve: .easeInOut,
            animations: animation
        ).startAnimation()
    }
}
