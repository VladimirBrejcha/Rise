//
//  TableView.swift
//  Rise
//
//  Created by Владимир Королев on 11.10.2019.
//  Copyright © 2019-2020 VladimirBrejcha. All rights reserved.
//

import UIKit

class TableView: UITableView {
    var cellTypes: [UITableViewCell.Type] { [] }
    
    private var cellIDs: [String] { cellTypes.map { String(describing: $0) } }
    private var nibNames: [String] { cellIDs }
    private var nibs: [UINib] {
        nibNames.map {
            UINib(nibName: $0, bundle: nil)
        }
    }
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        sharedInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        sharedInit()
    }
    
    private func sharedInit() {
        for index in cellIDs.indices {
            register(nibs[index], forCellReuseIdentifier: cellIDs[index])
        }
    }
}
