//
//  TableView.swift
//  Rise
//
//  Created by Vladimir Korolev on 11.10.2019.
//  Copyright © 2019-2020 VladimirBrejcha. All rights reserved.
//

import UIKit

class TableView: UITableView {
    var cellTypes: [UITableViewCell.Type] { [] }

    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        sharedInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        sharedInit()
    }
    
    private func sharedInit() {
        for cellType in cellTypes {
            register(
                cellType.self,
                forCellReuseIdentifier: String(describing: cellType.self)
            )
        }
    }
}
