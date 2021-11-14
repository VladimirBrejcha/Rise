//
//  EditScheduleDatePickerTableCell.swift
//  Rise
//
//  Created by Vladimir Korolev on 24.02.2020.
//  Copyright © 2020 VladimirBrejcha. All rights reserved.
//

import UIKit

final class EditScheduleDatePickerTableCell: UITableViewCell, ConfigurableCell {
    typealias Model = EditScheduleDatePickerTableCellModel

    @IBOutlet private weak var datePicker: UIDatePicker!
    @IBOutlet private weak var label: UILabel!
    
    private var datePickerDelegate: ((Date) -> Void)?
    
    @IBAction private func datePickerValueChanged(_ sender: UIDatePicker) {
        datePickerDelegate?(sender.date)
    }
    
    // MARK: - ConfigurableCell -
    func configure(with model: EditScheduleDatePickerTableCellModel) {
        label.text = model.text
        datePicker.setDate(model.initialValue, animated: false)
        datePickerDelegate = model.datePickerDelegate
    }
}
