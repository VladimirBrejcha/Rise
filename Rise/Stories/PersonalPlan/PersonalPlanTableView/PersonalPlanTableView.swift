//
//  PersonalPlanTableView.swift
//  Rise
//
//  Created by Владимир Королев on 24.02.2020.
//  Copyright © 2020 VladimirBrejcha. All rights reserved.
//

import UIKit

final class PersonalPlanTableView: TableView {
    override var cellTypes: [UITableViewCell.Type] { [ProgressTableViewCell.self, PlanInfoTableViewCell.self] }
}
