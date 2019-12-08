//
//  DaysCollectionViewDataSource.swift
//  Rise
//
//  Created by Владимир Королев on 09.12.2019.
//  Copyright © 2019 VladimirBrejcha. All rights reserved.
//

import Foundation

extension CollectionViewDataSource where Model == DaysCollectionViewCellModel {
    static func make(for cellModels: [DaysCollectionViewCellModel],
                     reuseIdentifier: String = String(describing: DaysCollectionViewCell.self),
                     cellDelegate: DaysCollectionViewCellDelegate) -> CollectionViewDataSource {
        
        return CollectionViewDataSource(models: cellModels, reuseIdentifier: reuseIdentifier)
        { (model, cell) in
            (cell as! DaysCollectionViewCell).cellModel = model
            (cell as! DaysCollectionViewCell).delegate = cellDelegate
        }
    }
}
