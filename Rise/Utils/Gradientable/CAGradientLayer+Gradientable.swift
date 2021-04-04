//
//  CAGradientLayer+Gradientable.swift
//  Rise
//
//  Created by Владимир Королев on 04.04.2021.
//  Copyright © 2021 VladimirBrejcha. All rights reserved.
//

import UIKit

extension CAGradientLayer: Gradientable {
    func apply(_ gradient: Gradient) {
        startPoint = gradient.position.start
        endPoint = gradient.position.end
        colors = gradient.colors
    }
}
