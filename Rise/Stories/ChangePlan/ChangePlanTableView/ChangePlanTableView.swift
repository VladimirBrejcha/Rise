//
//  SetupPlanDataSource.swift
//  Rise
//
//  Created by Vladimir Korolev on 30/09/2019.
//  Copyright © 2019-2020 VladimirBrejcha. All rights reserved.
//

import UIKit

final class ChangePlanTableView: TableView {
    override var cellTypes: [UITableViewCell.Type] { [ChangePlanDatePickerTableCell.self,
                                                      ChangePlanSliderTableCell.self,
                                                      ChangePlanButtonTableCell.self] }
}
