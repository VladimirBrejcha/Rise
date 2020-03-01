//
//  ChangePlanSliderTableCellModel.swift
//  Rise
//
//  Created by Владимир Королев on 24.02.2020.
//  Copyright © 2020 VladimirBrejcha. All rights reserved.
//

import Foundation

struct ChangePlanSliderTableCellModel {
    let title: String
    let text: (left: String, center: String, right: String)
    let sliderMinValue, sliderValue, sliderMaxValue: Float
    var centerLabelDataSource: (ChangePlanSliderTableCell, Float) -> String
}
