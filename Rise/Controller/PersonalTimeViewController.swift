//
//  PersonalTimeViewController.swift
//  Rise
//
//  Created by Vladimir Korolev on 25/05/2019.
//  Copyright © 2019 VladimirBrejcha. All rights reserved.
//

import UIKit

class PersonalTimeViewController: UITableViewController, PickerCellDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        // Get the correct height if the cell is a DatePickerCell.
        let cell = tableView.cellForRow(at: indexPath)
        if (cell is PickerCell) {
            return (cell as! PickerCell).datePickerHeight()
        }
        return super.tableView(tableView, heightForRowAt: indexPath)
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Deselect automatically if the cell is a DatePickerCell.
        let cell = self.tableView.cellForRow(at: indexPath)
        if (cell is PickerCell) {
            let datePickerTableViewCell = cell as! PickerCell
            datePickerTableViewCell.selectedInTableView(tableView)
            self.tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        if (cell is PickerCell) {
            let datePickerTableViewCell = cell as! PickerCell
            pickerCell(datePickerTableViewCell, didPickDate: nil)
            return datePickerTableViewCell
        } else {
            return UITableViewCell()
        }
    }
    
    func pickerCell(_ cell: PickerCell, didPickDate date: Date?) {
        switch cell.reuseIdentifier {
        case "0":
            print("0")
            cell.datePicker.isHidden = true
            cell.pickerView.isHidden = false
        case "1":
            cell.rightLabelTextColor = .red
            cell.datePicker.datePickerMode = .time
            cell.datePicker.locale = Locale(identifier: "ru")
        default:
            print("error")
        }
    }
}

