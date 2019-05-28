//
//  PersonalTimeViewController.swift
//  Rise
//
//  Created by Vladimir Korolev on 25/05/2019.
//  Copyright © 2019 VladimirBrejcha. All rights reserved.
//

import UIKit

class PersonalTimeViewController: UITableViewController, PickerCellDelegate {
    static var cellIdentifier = "wakeUpTimeCell"
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
        case "optionsCell":
            cell.datePicker.isHidden = true
            cell.pickerView.isHidden = false
            cell.rightLabel.text = "Set time"
            cell.leftLabel.text = "At:"
        case "wakeUpTimeCell", "fallAsleepTimeCell":
            cell.datePicker.datePickerMode = .time
            cell.datePicker.locale = Locale(identifier: "ru")
            cell.datePicker.setValue(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), forKeyPath: "textColor")
        case "sleepLongCell":
            cell.rightLabel.text = ""
            cell.datePicker.isHidden = true
            cell.pickerView.isHidden = false
        default:
            print("error")
        }
    }
}

extension PersonalTimeViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    public func pickerView(_ pickerView: UIPickerView,
                           numberOfRowsInComponent component: Int) -> Int {
        switch PersonalTimeViewController.cellIdentifier {
        case "optionsCell":
            return 4
        case "sleepLongCell":
            return 6
        default:
            return 1
        }
    }
    
    public func pickerView(_ pickerView: UIPickerView,
                           attributedTitleForRow row: Int,
                           forComponent component: Int) -> NSAttributedString? {
        
        switch PersonalTimeViewController.cellIdentifier {
        case "optionsCell":
            return NSAttributedString(string: Contstants.DataForPicker.timeYouHaveArray[row],
                                      attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        case "sleepLongCell":
            return NSAttributedString(string: Contstants.DataForPicker.wantedHoursOfSleep[row],
                                      attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        default:
            return NSAttributedString(string: Contstants.DataForPicker.timeYouHaveArray[row],
                                      attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        }
    }
    
}

