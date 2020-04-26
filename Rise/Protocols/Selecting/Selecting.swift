//
//  Selecting.swift
//  Rise
//
//  Created by Владимир Королев on 12.04.2020.
//  Copyright © 2020 VladimirBrejcha. All rights reserved.
//

import Foundation

typealias Selecting = IndexSelecting & ItemSelecting

typealias SingleSelecting = SingleIndexSelecting & SingleItemSelecting

enum SingleElementSelectableArrayError: Error {
    case indexOutOfBounds
    case elementDoesntExist
}
