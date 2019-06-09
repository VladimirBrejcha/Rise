//
//  PersonalTimeInputModel.swift
//  Rise
//
//  Created by Vladimir Korolev on 08/06/2019.
//  Copyright © 2019 VladimirBrejcha. All rights reserved.
//

import Foundation

struct PersonalTimeModel {
    var preferedWakeUpTime: String? {
        willSet {
            newPreferedWakeUpTime = convertData(data: newValue!)
        }
    }
    var preferedSleepDuration: String? {
        willSet {
            switch newValue {
            case DataForPicker.hoursArray[0]:
                newPreferedSleepDuration = 420
            case DataForPicker.hoursArray[1]:
                newPreferedSleepDuration = 450
            case DataForPicker.hoursArray[2]:
                newPreferedSleepDuration = 480
            case DataForPicker.hoursArray[3]:
                newPreferedSleepDuration = 510
            case DataForPicker.hoursArray[4]:
                newPreferedSleepDuration = 540
            default:
                fatalError("index doesnt exists")
            }
        }
    }
    var lastTimeAsleep: String? {
        willSet {
            newLastTimeAsleep = convertData(data: newValue!)
        }
    }
    var duration: String? {
        willSet {
            switch newValue {
            case DataForPicker.daysArray[0]:
                newDuration = 10
            case DataForPicker.daysArray[1]:
                newDuration = 15
            case DataForPicker.daysArray[2]:
                newDuration = 30
            case DataForPicker.daysArray[3]:
                newDuration = 50
            default:
                fatalError("index doesnt exists")
            }
        }
    }
    
    var newPreferedWakeUpTime: Date?
    var newPreferedSleepDuration: Int?
    var newLastTimeAsleep: Date?
    var newDuration: Int?
    
    var converter: PersonalTimeConverter?
    
    func buildData() {
        
    }
    
    mutating func convertData(data: String) -> Date {
        converter = PersonalTimeConverter()
        return (converter?.convertData(string: data))!
    }
}
