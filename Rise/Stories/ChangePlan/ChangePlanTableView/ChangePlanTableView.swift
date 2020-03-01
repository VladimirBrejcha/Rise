//
//  SetupPlanDataSource.swift
//  Rise
//
//  Created by Владимир Королев on 30/09/2019.
//  Copyright © 2019 VladimirBrejcha. All rights reserved.
//

import UIKit

final class ChangePlanTableView: TableView {
    override var cellTypes: [UITableViewCell.Type] { [ChangePlanDatePickerTableCell.self] }
}
