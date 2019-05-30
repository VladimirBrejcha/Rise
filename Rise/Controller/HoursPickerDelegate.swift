//
//  FirstPickerDelegate.swift
//  Rise
//
//  Created by Vladimir Korolev on 30/05/2019.
//  Copyright © 2019 VladimirBrejcha. All rights reserved.
//

import UIKit

class HoursPickerDelegate: NSObject, UIPickerViewDataSource, UIPickerViewDelegate {

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return Constants.DataForPicker.hoursArray.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return Constants.DataForPicker.hoursArray[row]
    }

}

class DaysPickerDelegate: NSObject, UIPickerViewDataSource, UIPickerViewDelegate {

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return Constants.DataForPicker.daysArray.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return Constants.DataForPicker.daysArray[row]
    }

}
