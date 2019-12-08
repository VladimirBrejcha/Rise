//
//  DaysCollectionView.swift
//  Rise
//
//  Created by Владимир Королев on 14.10.2019.
//  Copyright © 2019 VladimirBrejcha. All rights reserved.
//

import Foundation

final class DaysCollectionView: CollectionView {
    override var cellID: String {
        return String(describing: DaysCollectionViewCell.self)
    }
    override var nibName: String {
        return String(describing: DaysCollectionViewCell.self)
    }
}

extension CollectionViewDataSource where Model == DaysCollectionViewCellModel {
    static func make(for cellModels: [DaysCollectionViewCellModel],
                     reuseIdentifier: String = String(describing: DaysCollectionViewCell.self),
                     cellDelegate: DaysCollectionViewCellDelegate) -> CollectionViewDataSource {
        
        return CollectionViewDataSource (models: cellModels, reuseIdentifier: reuseIdentifier) { (model, cell) in
            (cell as! DaysCollectionViewCell).cellModel = model
            (cell as! DaysCollectionViewCell).delegate = cellDelegate
        }
    }
}
