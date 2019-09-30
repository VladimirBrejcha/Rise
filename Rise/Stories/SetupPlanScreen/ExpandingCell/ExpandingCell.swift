//
//  ExpandingCell.swift
//  Rise
//
//  Created by Vladimir Korolev on 30/05/2019.
//  Copyright © 2019 VladimirBrejcha. All rights reserved.
//

import UIKit
import AIFlatSwitch

enum PickerType {
    case datePicker
    case pickerView
}

protocol ExpandingCellDelegate: class {
    func cellValueUpdated(with value: PickerOutputValue, cell: ExpandingCell)
}

final class ExpandingCell: UITableViewCell, UIPickerViewDataSource, UIPickerViewDelegate {
    @IBOutlet weak var leftLabel: UILabel!
    @IBOutlet weak var pickerContainer: UIView!
    @IBOutlet weak var animatedSwitch: AIFlatSwitch!
    
    var textForPicker: [String]?
    var expanded = false
    private let unexpandedHeight: CGFloat = 44
    weak var delegate: ExpandingCellDelegate?
    
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter
    }()
    
    // MARK: User interaction methods
    func selectedInTableView(_ tableView: UITableView) {
        
        expanded = !expanded
        
        UIView.transition(with: leftLabel, duration: 0.25, options: [.transitionCrossDissolve, .allowUserInteraction], animations: { () in
            self.leftLabel.textColor
                = self.expanded
                ? self.tintColor
                : #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.75)
        }, completion: nil)
        
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
    @objc func dateChanged(sender: UIDatePicker) { pickerValueDidSet(sender.date) }
    
    private func toggleSwitch() {
        animatedSwitch.isHidden = false
        animatedSwitch.setSelected(true, animated: true)
    }
    
    // MARK: Picker methods
    public func createPicker(_ picker: PickerType, with defaultRow: Int?) {
        switch picker {
        case .datePicker: setupDatePicker()
        case .pickerView: setupPickerView(with: defaultRow ?? 0) }
    }
    
    public func pickerHeight() -> CGFloat {
        let expandedHeight = unexpandedHeight + 130
        return expanded ? expandedHeight : unexpandedHeight
    }
    
    private func setupPickerView(with defaultRow: Int) {
        let pickerView = UIPickerView()
        
        pickerView.delegate = self
        pickerView.dataSource = self
        
        pickerView.selectRow(defaultRow, inComponent: 0, animated: true)
        
        setUIForPicker(pickerView)
    }
    
    private func setupDatePicker() {
        
        let datePicker = UIDatePicker()
        
        datePicker.setValue(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), forKey: "textColor")
        datePicker.datePickerMode = .time
        datePicker.locale = Locale(identifier: "ru")
        
        datePicker.addTarget(self, action: #selector(dateChanged(sender:)), for: .valueChanged)
        
        setUIForPicker(datePicker)
    }
    
    private func setUIForPicker(_ picker: UIView) {
        
        pickerContainer.addSubview(picker)
        
        picker.translatesAutoresizingMaskIntoConstraints = false
        picker.heightAnchor.constraint(equalToConstant: 130).isActive = true
        picker.topAnchor.constraint(equalTo: pickerContainer.topAnchor, constant: 5).isActive = true
        picker.leftAnchor.constraint(equalTo: pickerContainer.leftAnchor).isActive = true
        picker.rightAnchor.constraint(equalTo: pickerContainer.rightAnchor).isActive = true
    }
    
    private func pickerValueDidSet(_ value: PickerOutputValue) {
        if let text = value.stringValue { leftLabel.text = text }
        if let date = value.dateValue { leftLabel.text = dateFormatter.string(from: date) }
        toggleSwitch()
        delegate?.cellValueUpdated(with: value, cell: self)
    }
    
}

// MARK: UIPickerViewDataSource && UIPickerViewDelegate
extension ExpandingCell {
    func numberOfComponents(in pickerView: UIPickerView) -> Int { return 1 }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int { return textForPicker?.count ?? 0}
    
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
