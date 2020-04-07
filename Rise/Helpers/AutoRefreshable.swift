//
//  AutoRefreshable.swift
//  Rise
//
//  Created by Владимир Королев on 07.04.2020.
//  Copyright © 2020 VladimirBrejcha. All rights reserved.
//

import Foundation

protocol AutoRefreshable: AnyObject {
    associatedtype DataSource
    var refreshInterval: Double { get set }
    var dataSource: DataSource? { get set }
    func refresh(_ dataSource: DataSource?)
}

extension AutoRefreshable {
    func beginRefreshing() {
        refresh(dataSource)
        Timer.scheduledTimer(withTimeInterval: refreshInterval, repeats: true) { [weak self] _ in
            self?.refresh(self?.dataSource)
        }
    }
}
