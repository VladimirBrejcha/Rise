//
//  ChangePlanSliderTableCell.swift
//  Rise
//
//  Created by Vladimir Korolev on 24.02.2020.
//  Copyright © 2020 VladimirBrejcha. All rights reserved.
//

import UIKit

final class ChangePlanSliderTableCell: UITableViewCell, ConfigurableCell {
    typealias Model = ChangePlanSliderTableCellModel
    
    @IBOutlet private weak var title: UILabel!
    @IBOutlet private weak var sliderWithValues: SliderWithValues!
    
    private var centerLabelDataSource: ((ChangePlanSliderTableCell, Float) -> String)?
    
    func configure(with model: Model) {
        title.text = model.title
        sliderWithValues.leftLabel.text = model.text.left
        sliderWithValues.centerLabel.text = model.text.center
        sliderWithValues.rightLabel.text = model.text.right
        sliderWithValues.slider.minimumValue = model.sliderMinValue
        sliderWithValues.slider.maximumValue = model.sliderMaxValue
        sliderWithValues.slider.setValue(model.sliderValue, animated: true)
        sliderWithValues.centerLabelDataSource = {
            model.centerLabelDataSource(self, $0)
        }
    }
}
