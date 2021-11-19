//
//  EditScheduleSliderTableCellModel.swift
//  Rise
//
//  Created by Vladimir Korolev on 24.02.2020.
//  Copyright © 2020 VladimirBrejcha. All rights reserved.
//

import Foundation

extension EditScheduleSliderTableCell {
    struct Model {
        let title: String
        let text: (left: String, center: String, right: String)
        let sliderMinValue, sliderValue, sliderMaxValue: Float
        var centerLabelDataSource: (EditScheduleSliderTableCell, Float) -> String
    }
}
