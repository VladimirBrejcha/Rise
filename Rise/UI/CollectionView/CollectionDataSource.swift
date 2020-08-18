//
//  CollectionDataSource.swift
//  Rise
//
//  Created by Владимир Королев on 18.02.2020.
//  Copyright © 2020 VladimirBrejcha. All rights reserved.
//

import UIKit

class CollectionDataSource: NSObject, UICollectionViewDataSource {
    var items: [CellConfigurator]

    required init(items: [CellConfigurator]) {
        self.items = items
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        items.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let item = items[indexPath.row]
        let reuseID = type(of: item).reuseId
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseID,
                                                      for: indexPath)
        item.configure(cell: cell)
        
        return cell
    }
}
