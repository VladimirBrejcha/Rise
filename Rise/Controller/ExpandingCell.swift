//
//  ExpandingCell.swift
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

    // MARK: Properties
    var expanded = false // Is the cell expanded?
    let unexpandedHeight: CGFloat = 44

    // MARK: Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    // MARK: User interaction methods
    open func selectedInTableView(_ tableView: UITableView) {

        expanded = !expanded

        UIView.transition(with: rightLabel,
                          duration: 0.25,
                          options: .transitionCrossDissolve,
                          animations: { () in
                            self.rightLabel.textColor
                                = self.expanded
                                ? self.tintColor
                                : UIColor(hue: 0.639,
                                          saturation: 0.041,
                                          brightness: 0.576,
                                          alpha: 1.0)},
                          completion: nil)

        tableView.beginUpdates()
        tableView.endUpdates()
    }

    // MARK: Picker methods
    open func createPicker(isDatePicker: Bool, delegate: NSObject? = nil) {
        if isDatePicker {
            let datePicker = UIDatePicker()
            setUIForPicker(datePicker)
        } else if isDatePicker == false {
            let pickerView = UIPickerView()
            pickerView.delegate = delegate as? UIPickerViewDelegate
            pickerView.dataSource = delegate as? UIPickerViewDataSource
            setUIForPicker(pickerView)
        }
    }

    private func setUIForPicker(_ picker: UIView) {
        pickerContainer.addSubview(picker)
        picker.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([NSLayoutConstraint(item: picker,
                                                        attribute: .bottom,
                                                        relatedBy: .equal,
                                                        toItem: pickerContainer,
                                                        attribute: .bottom,
                                                        multiplier: 1,
                                                        constant: 0),
                                     NSLayoutConstraint(item: picker,
                                                        attribute: .top,
                                                        relatedBy: .equal,
                                                        toItem: pickerContainer,
                                                        attribute: .top,
                                                        multiplier: 1,
                                                        constant: 0),
                                     NSLayoutConstraint(item: picker,
                                                        attribute: .left,
                                                        relatedBy: .equal,
                                                        toItem: pickerContainer,
                                                        attribute: .left,
                                                        multiplier: 1,
                                                        constant: 0),
                                     NSLayoutConstraint(item: picker,
                                                        attribute: .right,
                                                        relatedBy: .equal,
                                                        toItem: pickerContainer,
                                                        attribute: .right,
                                                        multiplier: 1,
                                                        constant: 0)])
    }

    open func pickerHeight() -> CGFloat {
        let expandedHeight = unexpandedHeight + 130 //TODO: change it to layout automatically
        return expanded ? expandedHeight : unexpandedHeight
    }

}
