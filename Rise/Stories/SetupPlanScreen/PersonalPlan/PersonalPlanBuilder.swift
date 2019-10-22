//
//  PersonalPlanBuilder.swift
//  Rise
//
//  Created by Владимир Королев on 29/09/2019.
//  Copyright © 2019 VladimirBrejcha. All rights reserved.
//

import Foundation

struct DailyPlanTimeModel {
    let day: Date
    var wake: Date
    var sleep: Date
}

class PersonalPlanBuilder {
    
    class func buildPlan(wakeUp: Date, wentSleep: Date, sleepDuration: String, planDuration: String) -> PersonalPlanModel {
        let today = Date()
        let sleepDuration = buildSleepDuration(from: sleepDuration)
        let finalSleepTime = buildFinalSleepTime(from: wakeUp, and: sleepDuration)
        let planDuration = daysToSeconds(buildPlanDuration(from: planDuration))
        let planEndDate = buildPlanEndDate(since: today, with: planDuration)
        
        return PersonalPlanModel(planStartSleepTime: wentSleep, finalWakeUpTime: wakeUp, finalSleepTime: finalSleepTime,
                                 sleepDurationSec: sleepDuration, planStartDate: today, planEndDate: planEndDate, planDuration: planDuration)
    }
    
    class func buildNewPlan(with wakeUpTime: Date, _ sleepDuration: String,  _ planDuration: String, _ wentSleep: Date,
                            _ completion: @escaping (Result<NewPersonalPlanModel, Error>) -> Void) {
        let today = Date()
        let planDuration = buildPlanDuration(from: planDuration)
        
        requestDailyModels(startingAt: today, for: planDuration) { result in
            if case .failure (let error) = result { completion(.failure(error)) }
            else if case .success (let sunModelArray) = result {
                
                let sleepDurationTime = buildSleepDuration(from: sleepDuration)
                let finalSleepTime = buildFinalSleepTime(from: wakeUpTime, and: sleepDurationTime)
                
                let timeBetweenNeededSleepAndActualSleep = Int(wentSleep.timeIntervalSince(finalSleepTime) / 60)
                
                let dailyShiftMin: Int = timeBetweenNeededSleepAndActualSleep > 1440
                ? (timeBetweenNeededSleepAndActualSleep - 1440) / planDuration
                : timeBetweenNeededSleepAndActualSleep / planDuration
                
                var dailyPlanTimesArray: [DailyTimesModel] = []
                
                for day in 1 ..< planDuration {
                    let dayDate = Calendar.current.date(byAdding: .day, value: day, to: today)!
                    let sleepDate = Calendar.current.date(byAdding: .minute, value: dailyShiftMin * day, to: wentSleep)!
                    let wakeDate = sleepDate.addingTimeInterval(sleepDurationTime)
                    let dailyPlanModel = DailyPlanTimeModel(day: dayDate, wake: wakeDate, sleep: sleepDate)
                    let sunModel = sunModelArray[day]
                    dailyPlanTimesArray.append(buildDailySunTimeModel(with: sunModel, and: dailyPlanModel))
                }
                let plan = NewPersonalPlanModel(planStartDay: today, planDuration: planDuration, finalSleepTime: finalSleepTime,
                                                    finalWakeTime: wakeUpTime, sleepDuration: sleepDurationTime, dailyTimes: dailyPlanTimesArray, latestConfirmedDay: today)
                completion(.success(plan))
            }
        }
    }
    
    // MARK: - Private methods
    private class func requestDailyModels(startingAt date: Date, for numberOfDays: Int, with completion: @escaping (Result<[SunTimeModel], Error>) -> Void) {
        sharedRepository.requestLocation { result in
            if case .failure (let error) = result { completion(.failure(error)) }
            else if case .success (let location) = result {
                sharedRepository.requestSunForecast(for: numberOfDays, at: date, with: location) { result in
                    if case .failure (let error) = result { completion(.failure(error)) }
                    else if case .success (let sunForecast) = result { completion(.success(sunForecast))  }
                }
            }
        }
    }
    
    private class func buildDailySunTimeModel(with sunTimeModel: SunTimeModel, and planTimeModel: DailyPlanTimeModel) -> DailyTimesModel {
        return DailyTimesModel(day: sunTimeModel.day, sunrise: sunTimeModel.sunrise, sunset: sunTimeModel.sunset, wake: planTimeModel.wake, sleep: planTimeModel.sleep)
    }
    
    private class func buildFinalSleepTime(from wakeUp: Date, and sleepDuration: Double) -> Date {
        return Date(timeInterval: -sleepDuration, since: wakeUp)
    }
    
    private class func buildSleepDuration(from string: String) -> Double {
        switch string
        {
        case DataForPicker.hoursArray[0]: return 420 * 60
        case DataForPicker.hoursArray[1]: return 450 * 60
        case DataForPicker.hoursArray[2]: return 480 * 60
        case DataForPicker.hoursArray[3]: return 510 * 60
        case DataForPicker.hoursArray[4]: return 540 * 60
        default: fatalError("index doesnt exists")
        }
    }
    
    private class func buildPlanDuration(from string: String) -> Int {
        switch string {
        case DataForPicker.daysArray[0]: return 10
        case DataForPicker.daysArray[1]: return 15
        case DataForPicker.daysArray[2]: return 30
        case DataForPicker.daysArray[3]: return 50
        default: fatalError("index doesnt exists")
        }
    }
    
    private class func buildPlanEndDate(since today: Date, with planDuration: Double) -> Date {
        return Date(timeInterval: planDuration, since: today)
    }
    
    private class func daysToSeconds(_ days: Int) -> Double {
        return Double(days * 24 * 60 * 60)
    }
    
}
