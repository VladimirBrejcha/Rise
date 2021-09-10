//
//  TouchObservable.swift
//  Rise
//
//  Created by Vladimir Korolev on 11.04.2020.
//  Copyright © 2020 VladimirBrejcha. All rights reserved.
//

import UIKit

protocol TouchDownObservable: AnyObject {
    associatedtype Control: UIControl
    var onTouchDown: ((Control) -> Void)? { get set }
}

protocol TouchUpObservable: AnyObject {
    associatedtype Control: UIControl
    var onTouchUp: ((Control) -> Void)? { get set }
}

typealias TouchObservable = TouchDownObservable & TouchUpObservable
