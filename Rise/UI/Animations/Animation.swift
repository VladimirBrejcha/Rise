//
//  Animation.swift
//  Rise
//
//  Created by Владимир Королев on 15.02.2020.
//  Copyright © 2020 VladimirBrejcha. All rights reserved.
//

import UIKit

struct AnimationKeys {
    static let scale = "transform.scale"
    static let opacity = "opacity"
    static let positionY = "position.y"
}

protocol Animation {
    func add(on layer: CALayer)
    func removeFromSuperlayer()
}
