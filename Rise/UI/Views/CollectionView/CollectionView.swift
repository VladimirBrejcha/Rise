//
//  CollectionView.swift
//  Rise
//
//  Created by Vladimir Korolev on 14.10.2019.
//  Copyright © 2019-2020 VladimirBrejcha. All rights reserved.
//

import UIKit

class CollectionView: UICollectionView {
    var cellTypes: [UICollectionViewCell.Type] { [] }

    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        sharedInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        sharedInit()
    }
    
    private func sharedInit() {
//        cellTypes.forEach { type in
//            let cellId = String(describing: type.self)
//            let nib = UINib(nibName: cellId, bundle: nil)
//            register(nib, forCellWithReuseIdentifier: cellId)
//        }
        cellTypes.forEach { type in
            register(
                type.self,
                forCellWithReuseIdentifier: String(describing: type.self)
            )
        }

    }
}
