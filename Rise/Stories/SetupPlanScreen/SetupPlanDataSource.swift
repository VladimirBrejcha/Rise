//
//  SetupPlanDataSource.swift
//  Rise
//
//  Created by Владимир Королев on 30/09/2019.
//  Copyright © 2019 VladimirBrejcha. All rights reserved.
//

import UIKit

fileprivate let sectionedCellID = "SectionedTableViewCell"
fileprivate let sectionedNibName = "SectionedTableViewCell"

class SectionedTableView: TableView {
    override var cellID: String { return sectionedCellID }
    override var nibName: String { return sectionedNibName }
}

extension TableViewDataSource where Model == PickerDataModel {
    static func make(for pickerData: [PickerDataModel], reuseIdentifier: String = sectionedCellID, output: SetupPlanViewOutput) -> TableViewDataSource {
        return TableViewDataSource(models: pickerData, reuseIdentifier: reuseIdentifier) { (model, cell) in
            guard let cell = cell as? SectionedTableViewCell else { return }
            cell.cellModel = model
            cell.delegate = output
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
