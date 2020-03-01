//
//  ChangePlanDatePickerTableCell.swift
//  Rise
//
//  Created by Владимир Королев on 24.02.2020.
//  Copyright © 2020 VladimirBrejcha. All rights reserved.
//

import UIKit

final class ChangePlanDatePickerTableCell: UITableViewCell, ConfigurableCell {
    typealias Model = ChangePlanDatePickerTableCellModel

    @IBOutlet private weak var datePicker: UIDatePicker!
    @IBOutlet private weak var label: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configure(with model: ChangePlanDatePickerTableCellModel) {
        label.text = model.text
        datePicker.setDate(model.initialValue, animated: false)
    }
}
