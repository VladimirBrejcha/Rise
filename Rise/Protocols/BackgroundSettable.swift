//
//  BackgroundSettable.swift
//  Rise
//
//  Created by Владимир Королев on 13.08.2020.
//  Copyright © 2020 VladimirBrejcha. All rights reserved.
//

import UIKit

protocol BackgroundSettable: UIView { }
extension BackgroundSettable {
    func setBackground(_ view: UIView) {
        addSubview(view)
        sendSubviewToBack(view)
    }
}
