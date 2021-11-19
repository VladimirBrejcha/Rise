//
//  EditScheduleButtonTableCellModel.swift
//  Rise
//
//  Created by Vladimir Korolev on 11.03.2020.
//  Copyright © 2020 VladimirBrejcha. All rights reserved.
//

import Foundation

extension EditScheduleButtonTableCell {
    struct Model {
        let title: String
        let action: () -> Void
    }
}
