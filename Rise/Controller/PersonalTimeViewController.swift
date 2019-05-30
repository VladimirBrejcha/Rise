//
//  PersonalTimeViewController.swift
//  Rise
//
//  Created by Vladimir Korolev on 25/05/2019.
//  Copyright © 2019 VladimirBrejcha. All rights reserved.
//

import UIKit

class PersonalTimeViewController: UITableViewController {

    var previouslySelectedCell: ExpandingCell?

    lazy var hoursPickerDelegate = HoursPickerDelegate()
    lazy var daysPickerDelegate = DaysPickerDelegate()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.register(UINib(nibName: "ExpandingCell", bundle: nil), forCellReuseIdentifier: "expandingCell")
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        // Get the correct height if the cell is a DatePickerCell.
        if let cell = tableView.cellForRow(at: indexPath) as? ExpandingCell {
            return cell.pickerHeight()
        }
        return super.tableView(tableView, heightForRowAt: indexPath)
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Deselect automatically if the cell is a DatePickerCell.
        if let cell = tableView.cellForRow(at: indexPath) as? ExpandingCell {
            if previouslySelectedCell != nil {
                if cell.expanded == false && previouslySelectedCell!.expanded {
                    previouslySelectedCell?.selectedInTableView(tableView)
                }
            }
            cell.selectedInTableView(tableView)

            self.tableView.deselectRow(at: indexPath, animated: true)
            previouslySelectedCell = cell
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        super.tableView(tableView, cellForRowAt: indexPath)

        if let cell = tableView.dequeueReusableCell(withIdentifier: "expandingCell") as? ExpandingCell {
            print(indexPath)
            switch indexPath.section {
            case 0, 2:
                cell.createPicker(isDatePicker: true)
                return cell
            case 1:
                cell.createPicker(isDatePicker: false, delegate: hoursPickerDelegate)
                return cell
            case 3:
                cell.createPicker(isDatePicker: false, delegate: daysPickerDelegate)
                return cell
            default:
                print("error")
                return cell
            }
        } else {
            return UITableViewCell()
        }
    }
}
