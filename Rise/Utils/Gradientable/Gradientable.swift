//
//  Gradientable.swift
//  Rise
//
//  Created by Владимир Королев on 04.04.2021.
//  Copyright © 2021 VladimirBrejcha. All rights reserved.
//

import CoreGraphics

struct Gradient {
    let position: (start: CGPoint, end: CGPoint)
    let colors: [CGColor]
}

protocol Gradientable {
    func apply(_ gradient: Gradient)
}
