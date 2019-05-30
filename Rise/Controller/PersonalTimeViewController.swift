//
//  PersonalTimeViewController.swift
//  Rise
//
//  Created by Vladimir Korolev on 25/05/2019.
//  Copyright © 2019 VladimirBrejcha. All rights reserved.
//

import UIKit

class PersonalTimeViewController: UITableViewController {

    // MARK: Properties
    var previouslySelectedCell: ExpandingCell?

    // MARK: Delegates
    lazy var hoursPickerDelegate = HoursPickerDelegate()
    lazy var daysPickerDelegate = DaysPickerDelegate()

    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.register(UINib(nibName: Constants.Cell.nibName, bundle: nil),
                           forCellReuseIdentifier: Constants.Cell.identifier)
    }

    // MARK: TableView methods
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        // Get the correct height if the cell is a DatePickerCell.
        guard let cell = tableView.cellForRow(at: indexPath) as? ExpandingCell else {
            return super.tableView(tableView, heightForRowAt: indexPath)
        }

        return cell.pickerHeight()
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Deselect automatically if the cell is a DatePickerCell.
        guard let cell = tableView.cellForRow(at: indexPath) as? ExpandingCell else { return }

        if previouslySelectedCell != nil && cell.expanded == false && previouslySelectedCell!.expanded {
            previouslySelectedCell?.selectedInTableView(tableView)
        }

        cell.selectedInTableView(tableView)

        self.tableView.deselectRow(at: indexPath, animated: true)

        previouslySelectedCell = cell
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        super.tableView(tableView, cellForRowAt: indexPath)

        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Cell.identifier) as? ExpandingCell else {
            return UITableViewCell()
        }

        switch indexPath.section {
        case 0, 2:
            cell.createPicker(isDatePicker: true)
        case 1:
            cell.createPicker(isDatePicker: false, delegate: hoursPickerDelegate)
        case 3:
            cell.createPicker(isDatePicker: false, delegate: daysPickerDelegate)
        default:
            print("error")
        }
        return cell
    }
}
