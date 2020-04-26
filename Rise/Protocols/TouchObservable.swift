//
//  Touchable.swift
//  Rise
//
//  Created by Владимир Королев on 11.04.2020.
//  Copyright © 2020 VladimirBrejcha. All rights reserved.
//

import UIKit

protocol TouchDownObservable: AnyObject {
    associatedtype Control: UIControl
    var touchDownObserver: ((inout Control) -> Void)? { get set }
}

protocol TouchUpObservable: AnyObject {
    associatedtype Control: UIControl
    var touchUpObserver: ((inout Control) -> Void)? { get set }
}

typealias TouchObservable = TouchDownObservable & TouchUpObservable
