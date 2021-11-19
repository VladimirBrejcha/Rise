//
//  TableCellConfigurator.swift
//  Rise
//
//  Created by Vladimir Korolev on 24.02.2020.
//  Copyright © 2020 VladimirBrejcha. All rights reserved.
//

import UIKit

final class TableCellConfigurator<CellType, Model>:
    CellConfigurator where CellType.Model == Model,
                           CellType: ConfigurableCell,
                           CellType: UITableViewCell,
                           CellType: SelfHeightSizing
{
    var height: CGFloat { CellType.height }
    static var reuseId: String { String(describing: CellType.self) }
    var model: Model
    
    required init(model: Model) {
        self.model = model
    }
    
    func configure(cell: UIView) {
        (cell as! CellType).configure(with: model)
    }
}
