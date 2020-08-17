//
//  AutoRefreshable.swift
//  Rise
//
//  Created by Владимир Королев on 07.04.2020.
//  Copyright © 2020 VladimirBrejcha. All rights reserved.
//

import Foundation

protocol Refreshable {
    associatedtype DataType
    func refresh(with data: DataType)
}

protocol AutoRefreshable: AnyObject, Refreshable {
    var timer: Timer? { get set }
    var dataSource: (() -> DataType)? { get set }
    var refreshInterval: Double { get set }
}

extension AutoRefreshable {
    func beginRefreshing() {
        guard let dataSource = dataSource else {
            print("AutoRefreshable.beginRefreshing failed, dataSource was nil")
            return
        }
        if timer != nil {
            timer?.invalidate()
            timer = nil
        }
        refresh(with: dataSource())
        timer = Timer.scheduledTimer(
            withTimeInterval: refreshInterval,
            repeats: true
        ) { [weak self] timer in
            guard let self = self else {
                timer.invalidate()
                return
            }
            self.refresh(with: dataSource())
        }
    }
    
    func stopRefreshing() {
        timer?.invalidate()
        timer = nil
    }
}
