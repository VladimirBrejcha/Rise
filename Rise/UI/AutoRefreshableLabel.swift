//
//  AutoRefreshableLabel.swift
//  Rise
//
//  Created by Владимир Королев on 11.04.2020.
//  Copyright © 2020 VladimirBrejcha. All rights reserved.
//

import UIKit

final class AutoRefreshableLabel: UILabel, AutoRefreshable {
    typealias DataSource = () -> String
    
    var dataSource: DataSource?
    
    var refreshInterval: Double = 2
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        sharedInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        sharedInit()
    }
    
    private func sharedInit() {
        beginRefreshing()
    }
    
    func refresh(_ dataSource: DataSource?) {
        self.text = dataSource?() ?? ""
    }
}
