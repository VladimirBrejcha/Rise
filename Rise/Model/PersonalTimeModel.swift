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
            convertedWakeUpTime = convertData(string: newValue!)
        }
    }
    
    var preferedSleepDuration: String? {
        willSet {
            switch newValue {
            case DataForPicker.hoursArray[0]:
                let newTime = Formater.dateFormatter.date(from: "07:00")
                convertedSleepDuration = newTime
            case DataForPicker.hoursArray[1]:
                let newTime = Formater.dateFormatter.date(from: "07:30")
                convertedSleepDuration = newTime
            case DataForPicker.hoursArray[2]:
                let newTime = Formater.dateFormatter.date(from: "08:00")
                convertedSleepDuration = newTime
            case DataForPicker.hoursArray[3]:
                let newTime = Formater.dateFormatter.date(from: "08:30")
                convertedSleepDuration = newTime
            case DataForPicker.hoursArray[4]:
                let newTime = Formater.dateFormatter.date(from: "09:00")
                convertedSleepDuration = newTime
            default:
                fatalError("index doesnt exists")
            }
        }
    }
    
    var timeWentSleep: String? {
        willSet {
            convertedTimeWentSleep = convertData(string: newValue!)
        }
    }
    
    var duration: String? {
        willSet {
            switch newValue {
            case DataForPicker.daysArray[0]:
                convertedDuration = 10
            case DataForPicker.daysArray[1]:
                convertedDuration = 15
            case DataForPicker.daysArray[2]:
                convertedDuration = 30
            case DataForPicker.daysArray[3]:
                convertedDuration = 50
            default:
                fatalError("index doesnt exists")
            }
        }
    }
    
    var convertedWakeUpTime: Date?
    var convertedSleepDuration: Date?
    var convertedTimeWentSleep: Date?
    var convertedDuration: Int?
    
    func convertData(string input: String) -> Date {
        
        guard let convertedData = Formater.dateFormatter.date(from: input) else {
            fatalError("Could'nt convert String to Date")
        }
        
        print(convertedData)
        return convertedData
    }
}
