//
//  EditScheduleSegmentedControlCell+Model.swift
//  Rise
//
//  Created by Vladimir Korolev on 19.11.2021.
//  Copyright © 2021 VladimirBrejcha. All rights reserved.
//

import UIKit

extension EditSchedule.TableView.SegmentedControlCell {
    struct Model {
        let title: String
        let selectedSegment: Int
        let segments: [UIAction]
    }
}
