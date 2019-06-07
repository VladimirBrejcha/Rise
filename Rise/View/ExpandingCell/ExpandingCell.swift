//
//  ExpandingCell.swift
//  Rise
//
//  Created by Vladimir Korolev on 30/05/2019.
//  Copyright © 2019 VladimirBrejcha. All rights reserved.
//

import UIKit
import AIFlatSwitch

class ExpandingCell: UITableViewCell {

    enum Picker {
        case datePicker
        case pickerView
    }

    // MARK: IBOutlets
    @IBOutlet weak var leftLabel: UILabel!
    @IBOutlet weak var pickerContainer: UIView!
    @IBOutlet weak var animatedSwitch: AIFlatSwitch!
    
    // MARK: Properties
    var expanded = false // Is the cell expanded?
    private let unexpandedHeight: CGFloat = 44
    var pickerDateModel: PickerDataModel?
    private lazy var dateFormatter = DateFormatter()

    // MARK: Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    // MARK: User interaction methods
    open func selectedInTableView(_ tableView: UITableView) {

        expanded = !expanded

        UIView.transition(with: leftLabel,
                          duration: 0.25,
                          options: .transitionCrossDissolve,
                          animations: { () in
                            self.leftLabel.textColor
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
    open func createPicker(_ picker: Picker, model pickerData: PickerDataModel? = nil) {
        switch picker {
        case .datePicker:
            setupDatePicker()
            
        case .pickerView:
            pickerDateModel = pickerData
            setupPickerView()
        }
    }
    
    private func setupPickerView() {
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

    @objc func dateChanged(sender: UIDatePicker) {

        let date = sender.date

        dateFormatter.timeStyle = .short
        dateFormatter.locale = Locale(identifier: "ru")

        leftLabel.text = dateFormatter.string(from: date)
    }

    open func pickerHeight() -> CGFloat {
        let expandedHeight = unexpandedHeight + 130
        return expanded ? expandedHeight : unexpandedHeight
    }

}

extension ExpandingCell: UIPickerViewDelegate, UIPickerViewDataSource {

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerDateModel?.numberOfRows ?? 1
    }

    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        return NSAttributedString(string: pickerDateModel?.titleForRowArray[row] ?? "Error loading data",
                                  attributes: [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)])
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        leftLabel.text = pickerDateModel?.titleForRowArray[pickerView.selectedRow(inComponent: component)]
        animatedSwitch.isHidden = false
        animatedSwitch.setSelected(true, animated: true)
    }

}
