//
//  ExpandingCell.swift
//  Rise
//
//  Created by Vladimir Korolev on 30/05/2019.
//  Copyright © 2019 VladimirBrejcha. All rights reserved.
//

import UIKit
import AIFlatSwitch

enum SectionedTableViewCellType {
    case datePicker
    case pickerView
}

protocol SectionedTableViewCellDelegate: AnyObject {
    func cellValueUpdated(with value: PickerOutputValue, cell: SectionedTableViewCell)
}

final class SectionedTableViewCell: UITableViewCell, UIPickerViewDataSource, UIPickerViewDelegate {
    weak var delegate: SectionedTableViewCellDelegate?
    
    @IBOutlet private weak var leftLabel: UILabel!
    @IBOutlet private weak var pickerContainer: UIView!
    @IBOutlet private weak var animatedSwitch: AIFlatSwitch!
    private var picker: Picker! {
        didSet {
            if let picker = picker as? UIDatePicker {
                picker.setValue(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), forKey: "textColor")
                picker.datePickerMode = .time
                picker.addTarget(self, action: #selector(dateChanged(sender:)), for: .valueChanged)
            } else if let picker = picker as? UIPickerView {
                picker.delegate = self
                picker.dataSource = self
                picker.selectRow(defaultPickerRow, inComponent: 0, animated: true)
            }
            setupConstraints(for: picker)
        }
    }
    
    var cellModel: PickerDataModel! {
        didSet {
            cellType = cellModel.type
            tag = cellModel.tag
            leftLabel.text = cellModel.labelText
        }
    }
    private var cellType: SectionedTableViewCellType! {
        didSet {
            if cellType == .datePicker { picker = UIDatePicker() }
            else if cellType == .pickerView {
                defaultPickerRow = cellModel.defaultRow
                textForPicker = cellModel.titleForRowArray
                picker = UIPickerView()
            }
        }
    }
    private var defaultPickerRow: Int!
    private var textForPicker: [String]?
    
    var expanded = false
    private let unexpandedHeight: CGFloat = 44
    private var expandedHeight: CGFloat { return unexpandedHeight + 130 }
    var pickerHeight: CGFloat { return expanded ? expandedHeight : unexpandedHeight }
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter
    }()
    
    func selectedInTableView(_ tableView: UITableView) {
        expanded = !expanded
        
        UIView.transition(with: leftLabel, duration: 0.25, options: [.transitionCrossDissolve, .allowUserInteraction], animations: {
            self.leftLabel.textColor
                = self.expanded
                ? self.tintColor
                : #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.75)
        }, completion: nil)
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
    private func toggleSwitch() {
        animatedSwitch.isHidden = false
        animatedSwitch.setSelected(true, animated: true)
    }
    
    @objc func dateChanged(sender: UIDatePicker) { pickerValueDidSet(sender.date) }
    
    private func setupConstraints(for picker: Picker) {
        if pickerContainer.subviews.isEmpty {
            pickerContainer.addSubview(picker)
            picker.translatesAutoresizingMaskIntoConstraints = false
            picker.heightAnchor.constraint(equalToConstant: 130).isActive = true
            picker.topAnchor.constraint(equalTo: pickerContainer.topAnchor, constant: 5).isActive = true
            picker.leftAnchor.constraint(equalTo: pickerContainer.leftAnchor).isActive = true
            picker.rightAnchor.constraint(equalTo: pickerContainer.rightAnchor).isActive = true
        }

    }
    
    private func pickerValueDidSet(_ value: PickerOutputValue) {
        if let text = value.stringValue { leftLabel.text = text }
        if let date = value.dateValue { leftLabel.text = dateFormatter.string(from: date) }
        toggleSwitch()
        delegate?.cellValueUpdated(with: value, cell: self)
    }
    
}

// MARK: UIPickerViewDataSource && UIPickerViewDelegate
extension SectionedTableViewCell {
    func numberOfComponents(in pickerView: UIPickerView) -> Int { return 1 }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int { return textForPicker?.count ?? 0 }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        return NSAttributedString(string: textForPicker?[row] ?? "", attributes: [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)])
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        pickerValueDidSet(textForPicker?[pickerView.selectedRow(inComponent: component)] ?? "")
    }
}

protocol PickerOutputValue { }
extension PickerOutputValue {
    var stringValue: String? { return self as? String }
    var dateValue: Date? { return self as? Date }
}
extension String: PickerOutputValue { }
extension Date: PickerOutputValue { }

fileprivate protocol Picker: UIView { }
extension UIPickerView: Picker { }
extension UIDatePicker: Picker { }
