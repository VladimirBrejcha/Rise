//
//  PersonalTimeInputModel.swift
//  Rise
//
//  Created by Vladimir Korolev on 08/06/2019.
//  Copyright © 2019 VladimirBrejcha. All rights reserved.
//

import Foundation

struct PersonalTimeModel {
    
    // MARK: Properties
    var preferedWakeUpTime: String? {
        willSet {
            convertedWakeUpTime = convertData(string: newValue!)
        }
    }
    
    var preferedSleepDuration: String? {
        willSet {
            switch newValue {
            case DataForPicker.hoursArray[0]:
                convertedSleepDuration = 420
            case DataForPicker.hoursArray[1]:
                convertedSleepDuration = 450
            case DataForPicker.hoursArray[2]:
                convertedSleepDuration = 480
            case DataForPicker.hoursArray[3]:
                convertedSleepDuration = 510
            case DataForPicker.hoursArray[4]:
                convertedSleepDuration = 540
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
    
    var calculator: PersonalTimeCalculator {
        let calculator = PersonalTimeCalculator(wakeUp: convertedWakeUpTime,
                                                sleepDuration: convertedSleepDuration,
                                                wentSleepTime: convertedTimeWentSleep,
                                                duration: convertedDuration)
        return calculator
    }
    
    // MARK: Converted properties
    var convertedWakeUpTime: Date!
    var convertedSleepDuration: Int!
    var convertedTimeWentSleep: Date!
    var convertedDuration: Int!
    
    // MARK: Methods
    func convertData(string input: String) -> Date {
        
        guard let convertedData = Formater.dateFormatter.date(from: input) else {
            fatalError("Could'nt convert String to Date")
        }
        
        return convertedData
    }
    
    func buildCalculator() {
//        let calculator = PersonalTimeCalculator(wakeUp: convertedWakeUpTime!,
//                                                sleepDuration: convertedSleepDuration!,
//                                                wentSleepTime: convertedTimeWentSleep!,
//                                                duration: convertedDuration!)
//
        print(calculator.result)
    }
    
}
