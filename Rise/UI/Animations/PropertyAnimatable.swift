//
//  PropertyAnimatable.swift
//  Rise
//
//  Created by Владимир Королев on 05.04.2020.
//  Copyright © 2020 VladimirBrejcha. All rights reserved.
//

import UIKit

protocol PropertyAnimatable {
    var propertyAnimationDuration: Double { get set }
}

extension PropertyAnimatable {
    func animate(_ animation: @escaping () -> Void) {
        DispatchQueue.main.async {
            UIViewPropertyAnimator(
                duration: self.propertyAnimationDuration,
                curve: .easeInOut,
                animations: animation
            ).startAnimation()
        }
    }
}
