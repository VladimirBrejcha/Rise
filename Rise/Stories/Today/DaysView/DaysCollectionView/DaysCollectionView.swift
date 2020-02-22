//
//  DaysCollectionView.swift
//  Rise
//
//  Created by Владимир Королев on 14.10.2019.
//  Copyright © 2019 VladimirBrejcha. All rights reserved.
//

import Foundation

final class DaysCollectionView: NewCollectionView {
    private let cellTypes = [DaysCollectionCell.self]
    
    override var cellIDs: [String] { cellTypes.compactMap { String(describing: $0) } }
}
