//
//  TableView.swift
//  Rise
//
//  Created by Владимир Королев on 11.10.2019.
//  Copyright © 2019 VladimirBrejcha. All rights reserved.
//

import UIKit

class TableView: UITableView {
    var cellID: String { return "" }
    var nibName: String { return "" }
    
    var nib: UINib { return UINib(nibName: nibName, bundle: nil) }
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        sharedInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        sharedInit()
    }
    
    private func sharedInit() { register(nib, forCellReuseIdentifier: cellID) }
}
