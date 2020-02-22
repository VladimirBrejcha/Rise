//
//  CellConfigurator.swift
//  Rise
//
//  Created by Владимир Королев on 18.02.2020.
//  Copyright © 2020 VladimirBrejcha. All rights reserved.
//

import UIKit

protocol CellConfigurator {
    static var reuseId: String { get }
    func configure(cell: UIView)
}
