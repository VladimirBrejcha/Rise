//
//  ExpandingCell.swift
//  Rise
//
//  Created by Vladimir Korolev on 30/05/2019.
//  Copyright © 2019 VladimirBrejcha. All rights reserved.
//

import UIKit
import AIFlatSwitch

final class ExpandingCell: UITableViewCell {

    enum Picker {
        case datePicker
        case pickerView
    }

    // MARK: IBOutlets
    @IBOutlet weak var leftLabel: UILabel!
    @IBOutlet weak var pickerContainer: UIView!
    @IBOutlet weak var animatedSwitch: AIFlatSwitch!
    
    // MARK: Properties
    public var expanded = false // Is the cell expanded?
    private let unexpandedHeight: CGFloat = 44
    private var pickerDataModel: PickerDataModel?
    private lazy var dateFormatter = DateFormatter()

    // MARK: Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    // MARK: User interaction methods
    public func selectedInTableView(_ tableView: UITableView) {
        
        expanded = !expanded
        
        UIView.transition(with: leftLabel, duration: 0.25, options: .transitionCrossDissolve, animations: { () in
            self.leftLabel.textColor
                = self.expanded
                ? self.tintColor
                : #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.75)
        }, completion: nil)
        
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
    @objc func dateChanged(sender: UIDatePicker) {
        
        let date = sender.date
        
        toggleSwitch()
        
        dateFormatter.timeStyle = .short
        dateFormatter.locale = Locale(identifier: "ru")
        
        leftLabel.text = dateFormatter.string(from: date)
    }
    
    private func toggleSwitch() {
        animatedSwitch.isHidden = false
        animatedSwitch.setSelected(true, animated: true)
    }
    
    // MARK: Picker methods
    public func createPicker(_ picker: Picker, model pickerData: PickerDataModel? = nil) {
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

}

// MARK: Extensions
extension ExpandingCell: UIPickerViewDelegate, UIPickerViewDataSource {

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerDataModel?.numberOfRows ?? 1
    }

    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        return NSAttributedString(string: pickerDataModel?.titleForRowArray[row] ?? "Error loading data",
                                  attributes: [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)])
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        leftLabel.text = pickerDataModel?.titleForRowArray[pickerView.selectedRow(inComponent: component)]
        toggleSwitch()
    }

}
