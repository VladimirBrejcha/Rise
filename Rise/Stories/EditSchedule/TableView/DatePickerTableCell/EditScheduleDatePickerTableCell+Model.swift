//
//  EditScheduleDatePickerTableCellModel.swift
//  Rise
//
//  Created by Vladimir Korolev on 24.02.2020.
//  Copyright © 2020 VladimirBrejcha. All rights reserved.
//

import Foundation

extension EditScheduleDatePickerTableCell {
    struct Model {
        let initialValue: Date
        let text: String
        let datePickerDelegate: ((Date) -> Void)
    }
}
