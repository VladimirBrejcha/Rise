//
//  Touchable.swift
//  Rise
//
//  Created by Владимир Королев on 11.04.2020.
//  Copyright © 2020 VladimirBrejcha. All rights reserved.
//

import Foundation

protocol Touchable {
    var touchStarted: ((Self) -> Void)? { get set }
    var touchCancelled: ((Self) -> Void)? { get set }
}
