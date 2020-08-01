//
//  DaysCollectionView.swift
//  Rise
//
//  Created by Владимир Королев on 14.10.2019.
//  Copyright © 2019-2020 VladimirBrejcha. All rights reserved.
//

import UIKit

final class DaysCollectionView: CollectionView {
    override var cellTypes: [UICollectionViewCell.Type] { [DaysCollectionCell.self] }
}
