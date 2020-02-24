//
//  TableCellConfigurator.swift
//  Rise
//
//  Created by Владимир Королев on 24.02.2020.
//  Copyright © 2020 VladimirBrejcha. All rights reserved.
//

import UIKit

final class TableCellConfigurator<CellType: ConfigurableCell, Model>: CellConfigurator
    where CellType.Model == Model, CellType: UITableViewCell
{
    static var reuseId: String { String(describing: CellType.self) }
    
    var model: Model
    
    required init(model: Model) {
        self.model = model
    }
    
    func configure(cell: UIView) {
        (cell as! CellType).configure(with: model)
    }
}

