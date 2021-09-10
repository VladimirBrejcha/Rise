//
//  ConfigurableCell.swift
//  Rise
//
//  Created by Vladimir Korolev on 18.02.2020.
//  Copyright © 2020 VladimirBrejcha. All rights reserved.
//

import Foundation

protocol ConfigurableCell {
    associatedtype Model
    func configure(with model: Model)
}
