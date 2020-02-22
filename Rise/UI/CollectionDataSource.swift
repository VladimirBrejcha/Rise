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

    init(items: [CellConfigurator]) {
        self.items = items
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = items[indexPath.row]
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: type(of: item).reuseId, for: indexPath)
        item.configure(cell: cell)
        
        return cell
    }
}
