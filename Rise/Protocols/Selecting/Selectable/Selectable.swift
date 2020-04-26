//
//  Selectable.swift
//  Rise
//
//  Created by Владимир Королев on 12.04.2020.
//  Copyright © 2020 VladimirBrejcha. All rights reserved.
//

import Foundation

protocol Selectable {
    var isSelected: Bool { get set }
}

typealias SelectableItem = Selectable & Equatable
typealias TouchableSelectableItem = SelectableItem & TouchObservable
