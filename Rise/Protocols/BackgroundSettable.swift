//
//  BackgroundSettable.swift
//  Rise
//
//  Created by Владимир Королев on 13.08.2020.
//  Copyright © 2020 VladimirBrejcha. All rights reserved.
//

import UIKit

protocol BackgroundSettable: AnyObject { }
extension BackgroundSettable where Self: UIView {
    func setBackground(_ view: UIView) {
        addSubview(view)
        sendSubviewToBack(view)
    }
}

extension BackgroundSettable where Self: UIViewController {
    func setBackground(_ view: UIView) {
        self.view.addSubview(view)
        self.view.sendSubviewToBack(view)
    }
}
