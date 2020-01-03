//
//  PickerDataModel.swift
//  Rise
//
//  Created by Vladimir Korolev on 02/06/2019.
//  Copyright © 2019 VladimirBrejcha. All rights reserved.
//

import UIKit

struct PickerDataModel {
    var tag: Int
    var headerText: String
    var labelText: String
    var type: SectionedTableViewCellType
    var titleForRowArray: [String]? // only for pickerView
    var defaultRow: Int? // only for pickerView
}
