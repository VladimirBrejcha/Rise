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
    private let unexpandedHeight: CGFloat = 44
    private lazy var dateFormatter = DateFormatter()

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
            datePicker.setValue(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), forKey: "textColor")
            datePicker.datePickerMode = .time
            datePicker.locale = Locale(identifier: "ru")
            datePicker.addTarget(self, action: #selector(dateChanged(sender:)), for: .valueChanged)
            setUIForPicker(datePicker)
        } else if isDatePicker == false {
            let pickerView = UIPickerView()
            pickerView.delegate = delegate as? UIPickerViewDelegate
            pickerView.dataSource = delegate as? UIPickerViewDataSource
            setUIForPicker(pickerView)
        }
    }

    @objc func dateChanged(sender: UIDatePicker) {

        let date = sender.date

        dateFormatter.timeStyle = .short
        dateFormatter.locale = Locale(identifier: "ru")

        rightLabel.text = dateFormatter.string(from: date)
    }

    @objc func pickerValueChanged(sender: UIPickerView) {
        //чтобы этот метод вызвался и присвоил лэйблу эту инфу
        rightLabel.text = ""
    }

    private func setUIForPicker(_ picker: UIView) {
        pickerContainer.addSubview(picker)

        picker.translatesAutoresizingMaskIntoConstraints = false
        picker.bottomAnchor.constraint(equalTo: pickerContainer.bottomAnchor).isActive = true
        picker.topAnchor.constraint(equalTo: pickerContainer.topAnchor, constant: 5).isActive = true
        picker.leftAnchor.constraint(equalTo: pickerContainer.leftAnchor).isActive = true
        picker.rightAnchor.constraint(equalTo: pickerContainer.rightAnchor).isActive = true
    }

    open func pickerHeight() -> CGFloat {
        let expandedHeight = unexpandedHeight + 130 //TODO: change it to layout automatically
        return expanded ? expandedHeight : unexpandedHeight
    }

}
