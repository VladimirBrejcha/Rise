//
//  CollectionCellConfigurator.swift
//  Rise
//
//  Created by Владимир Королев on 18.02.2020.
//  Copyright © 2020 VladimirBrejcha. All rights reserved.
//

import UIKit

final class CollectionCellConfigurator<CellType: ConfigurableCell, Model>:
    CellConfigurator
    where
    CellType.Model == Model,
    CellType: UICollectionViewCell
{
    static var reuseId: String { String(describing: CellType.self) }
    
    var model: Model

    init(model: Model) {
        self.model = model
    }

    func configure(cell: UIView) {
        (cell as! CellType).configure(with: model)
    }
}
