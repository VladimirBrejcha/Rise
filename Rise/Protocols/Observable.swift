//
//  Observable.swift
//  Rise
//
//  Created by Владимир Королев on 18.04.2020.
//  Copyright © 2020 VladimirBrejcha. All rights reserved.
//

import Foundation

protocol Observable {
    associatedtype Value
    var observer: ((Value) -> Void)? { get set }
}
