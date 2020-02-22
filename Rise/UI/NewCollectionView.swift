//
//  NewCollectionView.swift
//  Rise
//
//  Created by Владимир Королев on 18.02.2020.
//  Copyright © 2020 VladimirBrejcha. All rights reserved.
//

import UIKit

class NewCollectionView: UICollectionView {
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
