//
//  CollectionView.swift
//  Rise
//
//  Created by Владимир Королев on 14.10.2019.
//  Copyright © 2019 VladimirBrejcha. All rights reserved.
//

import UIKit

class CollectionView: UICollectionView {
    var cellIDs: [String] { [] }
    
    private var nibNames: [String] { cellIDs }
    
    private var nibs: [UINib] {
        nibNames.map {
            UINib(nibName: $0, bundle: nil)
        }
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
        for index in cellIDs.indices {
            register(nibs[index], forCellWithReuseIdentifier: cellIDs[index])
        }
    }
}
