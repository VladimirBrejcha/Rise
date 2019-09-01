//
//  MyTableViewCell.swift
//  Rise
//
//  Created by Vladimir Korolev on 30/05/2019.
//  Copyright © 2019 VladimirBrejcha. All rights reserved.
//

import UIKit

class ExpandingCell: UITableViewCell {

    // MARK: IBOutlets
    @IBOutlet weak var leftLabel: UILabel!
    @IBOutlet weak var rightLabel: UILabel!
    @IBOutlet weak var pickerContainer: UIView!

    // MARK: properties
    var expanded = false // Is the cell expanded?
    let unexpandedHeight: CGFloat = 44

    // MARK: Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    open func selectedInTableView(_ tableView: UITableView) {
        expanded = !expanded

        UIView.transition(with: rightLabel,
                          duration: 0.25,
                          options: UIView.AnimationOptions.transitionCrossDissolve,
                          animations: { () -> Void in
                            self.rightLabel.textColor
                                = self.expanded
                                ? self.tintColor
                                : UIColor(hue: 0.639, saturation: 0.041, brightness: 0.576, alpha: 1.0)

        },
                          completion: nil)

        tableView.beginUpdates()
        tableView.endUpdates()
    }

    open func createItem(isDatePicker: Bool) {
        if isDatePicker {
            let datePicker = UIDatePicker()
            createPicker(datePicker)
        } else if isDatePicker == false {
            let pickerView = UIPickerView()
            pickerView.delegate = firstPickerDelegate
            pickerView.dataSource = firstPickerDelegate
            createPicker(pickerView)
        }
    }

    func createPicker(_ picker: UIView) {
        pickerContainer.addSubview(picker)
        picker.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: picker,
                           attribute: .height,
                           relatedBy: .equal,
                           toItem: nil,
                           attribute: .notAnAttribute,
                           multiplier: 1,
                           constant: 130).isActive = true
        NSLayoutConstraint(item: picker,
                           attribute: .top,
                           relatedBy: .equal,
                           toItem: pickerContainer,
                           attribute: .top,
                           multiplier: 1,
                           constant: 0).isActive = true
        NSLayoutConstraint(item: picker,
                           attribute: .left,
                           relatedBy: .equal,
                           toItem: pickerContainer,
                           attribute: .left,
                           multiplier: 1,
                           constant: 0).isActive = true
        NSLayoutConstraint(item: picker,
                           attribute: .right,
                           relatedBy: .equal,
                           toItem: pickerContainer,
                           attribute: .right,
                           multiplier: 1,
                           constant: 0).isActive = true
    }

    open func pickerHeight() -> CGFloat {
        let expandedHeight = unexpandedHeight + 130
        return expanded ? expandedHeight : unexpandedHeight
    }

}
