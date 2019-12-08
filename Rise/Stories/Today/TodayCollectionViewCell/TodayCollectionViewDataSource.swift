//
//  TodayCollectionViewDataSource.swift
//  Rise
//
//  Created by Владимир Королев on 14.10.2019.
//  Copyright © 2019 VladimirBrejcha. All rights reserved.
//

import Foundation

fileprivate let todayCellID = "TodayCollectionViewCell"
fileprivate let todayNibName = "TodayCollectionViewCell"

class TodayCollectionView: ColectionView {
    override var cellID: String { return todayCellID }
    override var nibName: String { return todayNibName }
}

extension CollectionViewDataSource where Model == TodayCellModel {
    static func make(for cellModels: [TodayCellModel], reuseIdentifier: String = todayCellID,
                     cellDelegate: TodayCollectionViewCellDelegate) -> CollectionViewDataSource {
        
        return CollectionViewDataSource (models: cellModels, reuseIdentifier: reuseIdentifier) { (model, cell) in
            (cell as! TodayCollectionViewCell).cellModel = model
            (cell as! TodayCollectionViewCell).delegate = cellDelegate
        }
    }
}
