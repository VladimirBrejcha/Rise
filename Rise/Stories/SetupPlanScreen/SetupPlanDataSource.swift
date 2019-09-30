//
//  SetupPlanDataSource.swift
//  Rise
//
//  Created by Владимир Королев on 30/09/2019.
//  Copyright © 2019 VladimirBrejcha. All rights reserved.
//

import UIKit

extension TableViewDataSource where Model == PickerDataModel {
    static func make(for pickerData: [PickerDataModel], reuseIdentifier: String = "expandingCell", output: SetupPlanViewOutput) -> TableViewDataSource {
        return TableViewDataSource(models: pickerData, reuseIdentifier: reuseIdentifier) { (model, cell) in
            guard let cell = cell as? ExpandingCell else { return }
            cell.leftLabel.text = model.labelText
            cell.delegate = output
            cell.tag = model.tag
            cell.createPicker(model.pickerType, with: model.defaultRow)
            cell.textForPicker = model.titleForRowArray
        }
    }
}

extension SectionedTableViewDataSource: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int { return dataSources.count }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let dataSource = dataSources[section]
        return dataSource.tableView(tableView, numberOfRowsInSection: 0)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let dataSource = dataSources[indexPath.section]
        let indexPath = IndexPath(row: indexPath.row, section: 0)
        return dataSource.tableView(tableView, cellForRowAt: indexPath)
    }
}
