//
//  ChangePlanSliderTableCell.swift
//  Rise
//
//  Created by Владимир Королев on 24.02.2020.
//  Copyright © 2020 VladimirBrejcha. All rights reserved.
//

import UIKit

final class ChangePlanSliderTableCell: UITableViewCell, ConfigurableCell {
    typealias Model = ChangePlanSliderTableCellModel
    
    @IBOutlet private weak var title: UILabel!
    @IBOutlet private weak var centerLabel: UILabel!
    @IBOutlet private weak var leftLabel: UILabel!
    @IBOutlet private weak var rightLabel: UILabel!
    @IBOutlet private weak var slider: UISlider!
    
    private var sliderValueChanged: ((Float) -> Void)?
    
    func configure(with model: ChangePlanSliderTableCellModel) {
        title.text = model.title
        leftLabel.text = model.text.left
        centerLabel.text = model.text.center
        rightLabel.text = model.text.right
        slider.minimumValue = model.sliderMinValue
        slider.maximumValue = model.sliderMaxValue
        slider.setValue(model.sliderValue, animated: true)
        sliderValueChanged = model.sliderValueChanged
    }
    
    @IBAction func sliderValueChanged(_ sender: UISlider) {
        centerLabel.text = Double(sender.value).HHmmString
        sliderValueChanged?(sender.value)
    }
}
