//
//  AutoRefreshableLabel.swift
//  Rise
//
//  Created by Владимир Королев on 11.04.2020.
//  Copyright © 2020 VladimirBrejcha. All rights reserved.
//

import UIKit

final class AutoRefreshableLabel: UILabel, AutoRefreshable {
    var timer: Timer?
    var dataSource: (() -> String)?
    var refreshInterval: Double = 1
    
    func refresh(with data: String) { text = data }
}
