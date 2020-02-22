//
//  DaysCollectionCellModel.swift
//  Rise
//
//  Created by Владимир Королев on 22.02.2020.
//  Copyright © 2020 VladimirBrejcha. All rights reserved.
//

import Foundation

enum DaysCollectionCellState {
    case loading
    case showingInfo (info: String)
    case showingError (error: String)
    case showingContent (left: String, right: String)
}

struct DaysCollectionCellModel {
    var state: DaysCollectionCellState
    let imageName: (left: String, right: String)
    let repeatButtonHandler: ((DaysCollectionCell) -> Void)?
}
