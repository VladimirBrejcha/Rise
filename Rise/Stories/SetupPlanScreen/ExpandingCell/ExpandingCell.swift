//
//  ExpandingCell.swift
//  Rise
//
//  Created by Vladimir Korolev on 30/05/2019.
//  Copyright © 2019 VladimirBrejcha. All rights reserved.
//

import UIKit
import AIFlatSwitch

protocol ExpandingCellDelegate: class {
    func cellValueUpdated(with value: PickerOutputValue, cell: ExpandingCell)
}

final class ExpandingCell: UITableViewCell, UIPickerViewDataSource, UIPickerViewDelegate {
    enum PickerType {
        case datePicker
        case pickerView
    }
    @IBOutlet weak var leftLabel: UILabel!
    @IBOutlet weak var pickerContainer: UIView!
    @IBOutlet weak var animatedSwitch: AIFlatSwitch!
    
    public var expanded = false
    private let unexpandedHeight: CGFloat = 44
    private var pickerDataModel: PickerDataModel?
    weak var delegate: ExpandingCellDelegate?
    
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
    public func createPicker(_ picker: PickerType, model pickerData: PickerDataModel? = nil) {
        switch picker {
        case .datePicker:
            setupDatePicker()
            
        case .pickerView:
            setupPickerView(dataModel: pickerData)
        }
    }
    
    public func pickerHeight() -> CGFloat {
        let expandedHeight = unexpandedHeight + 130
        return expanded ? expandedHeight : unexpandedHeight
    }
    
    private func setupPickerView(dataModel: PickerDataModel? = nil) {
        
        pickerDataModel = dataModel
        
        let pickerView = UIPickerView()
        
        pickerView.delegate = self
        pickerView.dataSource = self
        
        pickerView.selectRow(pickerDataModel?.defaultRow ?? 0,
                             inComponent: 0,
                             animated: true)
        
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
        toggleSwitch()
        delegate?.cellValueUpdated(with: value, cell: self)
    }
    
}

// MARK: UIPickerViewDataSource && UIPickerViewDelegate
extension ExpandingCell {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int { return 1 }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int { return pickerDataModel?.numberOfRows ?? 1 }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        return NSAttributedString(string: pickerDataModel?.titleForRowArray[row] ?? "Error loading data",
                                  attributes: [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)])
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        guard let value = pickerDataModel?.titleForRowArray[pickerView.selectedRow(inComponent: component)] else { fatalError() }
        pickerValueDidSet(value)
    }
}

protocol PickerOutputValue { }
extension PickerOutputValue {
    var stringValue: String? { return self as? String }
    var dateValue: Date? { return self as? Date }
}
extension String: PickerOutputValue { }
extension Date: PickerOutputValue { }
