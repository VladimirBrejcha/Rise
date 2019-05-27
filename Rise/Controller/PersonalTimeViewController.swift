//
//  PersonalTimeViewController.swift
//  Rise
//
//  Created by Vladimir Korolev on 25/05/2019.
//  Copyright © 2019 VladimirBrejcha. All rights reserved.
//

import UIKit

class PersonalTimeViewController: UITableViewController, PickerCellDelegate {
    static var numberOfCell = 0
    var previousCell: PickerCell?

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        // Get the correct height if the cell is a DatePickerCell.
        if let cell = tableView.cellForRow(at: indexPath) as? PickerCell {
            return cell.datePickerHeight()
        }
        return super.tableView(tableView, heightForRowAt: indexPath)
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        // Deselect automatically if the cell is a DatePickerCell.
        if let cell = self.tableView.cellForRow(at: indexPath) as? PickerCell {
            if previousCell != nil {
                if cell.expanded == false && previousCell!.expanded {
                    previousCell?.selectedInTableView(tableView)
                }
            }
            cell.selectedInTableView(tableView)
            self.tableView.deselectRow(at: indexPath, animated: true)
            previousCell = cell
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = super.tableView(tableView, cellForRowAt: indexPath) as? PickerCell {
            pickerCell(cell, didPickDate: nil)
            return cell
        } else {
            return UITableViewCell()
        }
    }

    func pickerCell(_ cell: PickerCell, didPickDate date: Date?) {
        switch cell.reuseIdentifier {
        case "0":
            PersonalTimeViewController.numberOfCell = 0
            cell.datePicker.isHidden = true
            cell.pickerView.isHidden = false
            cell.rightLabel.text = "Set time"
            cell.leftLabel.text = "At:"
        case "1", "2":
            PersonalTimeViewController.numberOfCell = 2
            cell.datePicker.datePickerMode = .time
            cell.datePicker.locale = Locale(identifier: "ru")
            cell.datePicker.setValue(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), forKeyPath: "textColor")
        case "3":
            PersonalTimeViewController.numberOfCell = 3
            cell.rightLabel.text = ""
            cell.datePicker.isHidden = true
            cell.pickerView.isHidden = false
        default:
            print("error")
        }
    }
}
