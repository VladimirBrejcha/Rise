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
    var labelText: String
    var type: ExpandingCellType
    var titleForRowArray: [String]?
    var defaultRow: Int?
}
