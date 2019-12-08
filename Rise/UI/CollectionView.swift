//
//  CollectionView.swift
//  Rise
//
//  Created by Владимир Королев on 14.10.2019.
//  Copyright © 2019 VladimirBrejcha. All rights reserved.
//

import UIKit

class CollectionView: UICollectionView {
    var cellID: String {
        return String()
    }
    var nibName: String {
        return String()
    }

    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        sharedInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        sharedInit()
    }
    
    private func sharedInit() {
        register(UINib(nibName: nibName, bundle: nil), forCellWithReuseIdentifier: cellID)
    }
}
