//
//  ModelBuilder.swift
//  Rise
//
//  Created by Владимир Королев on 05.11.2019.
//  Copyright © 2019 VladimirBrejcha. All rights reserved.
//

import Foundation
import CoreData

protocol Builder {
    func buildPlan(with wakeUpTime: Date, _ sleepDuration: String,  _ planDuration: String, _ wentSleep: Date,
                   _ completion: @escaping (Result<PersonalPlan, Error>) -> Void)
    
    func buildDailySunTimeModel(from dailySunTime: RiseDailySunTime) -> DailySunTime
    func update(sunTimeObject: RiseDailySunTime, with model: DailySunTime)
    
    func buildLocationModel(from location: RiseLocation) -> Location
    func update(locationObject: RiseLocation, with model: Location)
}

class ModelBuilder: Builder {
    // TODO: - might not handle cases where new sleep time > needed sleep time
    func buildPlan(with wakeUpTime: Date, _ sleepDuration: String,  _ planDuration: String, _ wentSleep: Date,
                            _ completion: @escaping (Result<PersonalPlan, Error>) -> Void) {
        let today = Date()
        let planDuration = buildPlanDuration(from: planDuration)
        
        requestDailyModels(startingAt: today, for: planDuration) { result in
            if case .failure (let error) = result { completion(.failure(error)) }
            else if case .success (let sunModelArray) = result {
                
                let sleepDurationTime = self.buildSleepDuration(from: sleepDuration)
                let finalSleepTime = self.buildFinalSleepTime(from: wakeUpTime, and: sleepDurationTime)
                
                let timeBetweenNeededSleepAndActualSleep = Int(wentSleep.timeIntervalSince(finalSleepTime) / 60)
                
                let dailyShiftMin: Int = timeBetweenNeededSleepAndActualSleep > 1440
                    ? -(timeBetweenNeededSleepAndActualSleep - 1440) / planDuration
                    : -timeBetweenNeededSleepAndActualSleep / planDuration
                
                var dailyPlanTimesArray: [DailyPlanTime] = []
                
                for day in 1 ..< planDuration + 1 {
                    let dayDate = Calendar.current.date(byAdding: .day, value: day, to: today)!
                    let sleepDate = Calendar.current.date(byAdding: .minute, value: dailyShiftMin * day, to: wentSleep)!
                    let wakeDate = sleepDate.addingTimeInterval(sleepDurationTime)
                    let dailyPlanModel = DailyPlanTime(day: dayDate, wake: wakeDate, sleep: sleepDate)
                    let sunModel = sunModelArray[day]
                    dailyPlanTimesArray.append(dailyPlanModel)
                }
                let plan = PersonalPlan(planStartDay: today, planDuration: planDuration, finalSleepTime: finalSleepTime,
                                             finalWakeTime: wakeUpTime, sleepDuration: sleepDurationTime,
                                             dailyTimes: dailyPlanTimesArray, latestConfirmedDay: today)
                completion(.success(plan))
            }
        }
    }
    
    // MARK: - DailySunTimeModel -
    func buildDailySunTimeModel(from dailySunTime: RiseDailySunTime) -> DailySunTime {
        return DailySunTime(day: dailySunTime.day, sunrise: dailySunTime.sunrise, sunset: dailySunTime.sunset)
    }
    
    func update(sunTimeObject: RiseDailySunTime, with model: DailySunTime) {
        sunTimeObject.day = model.day
        sunTimeObject.sunrise = model.sunrise
        sunTimeObject.sunset = model.sunset
    }
    
    // MARK: - Location -
    func buildLocationModel(from location: RiseLocation) -> Location {
        return Location(latitude: location.latitude, longitude: location.longitude)
    }
    
    func update(locationObject: RiseLocation, with model: Location) {
        locationObject.latitude = model.latitude
        locationObject.longitude = model.longitude
    }
    
    // MARK: - Private methods
    private func requestDailyModels(startingAt date: Date, for numberOfDays: Int, with completion: @escaping (Result<[DailySunTime], Error>) -> Void) {
//        sharedRepository.requestLocation { result in
//            if case .failure (let error) = result { completion(.failure(error)) }
//            else if case .success (let location) = result {
//                sharedRepository.requestSunForecast(for: numberOfDays, at: date, with: location) { result in
//                    if case .failure (let error) = result { completion(.failure(error)) }
//                    else if case .success (let sunForecast) = result { completion(.success(sunForecast))  }
//                }
//            }
//        }
    }
    
    private func buildDailySunTimeModel(with sunTimeModel: DailySunTime, and planTimeModel: DailyPlanTime) -> DailyTimeModel {
        return DailyTimeModel(day: sunTimeModel.day, sunrise: sunTimeModel.sunrise, sunset: sunTimeModel.sunset, wake: planTimeModel.wake, sleep: planTimeModel.sleep)
    }
    
    private func buildFinalSleepTime(from wakeUp: Date, and sleepDuration: Double) -> Date {
        return Date(timeInterval: -sleepDuration, since: wakeUp)
    }
    
    private func buildSleepDuration(from string: String) -> Double {
        switch string
        {
        case DataForPicker.hoursArray[0]: return 420 * 60
        case DataForPicker.hoursArray[1]: return 450 * 60
        case DataForPicker.hoursArray[2]: return 480 * 60
        case DataForPicker.hoursArray[3]: return 510 * 60
        case DataForPicker.hoursArray[4]: return 540 * 60
        default: fatalError("index doesnt exist")
        }
    }
    
    private func buildPlanDuration(from string: String) -> Int {
        switch string {
        case DataForPicker.daysArray[0]: return 10
        case DataForPicker.daysArray[1]: return 15
        case DataForPicker.daysArray[2]: return 30
        case DataForPicker.daysArray[3]: return 50
        default: fatalError("index doesnt exist")
        }
    }
    
    private func buildPlanEndDate(since today: Date, with planDuration: Double) -> Date {
        return Date(timeInterval: planDuration, since: today)
    }
    
    private func daysToSeconds(_ days: Int) -> Double {
        return Double(days * 24 * 60 * 60)
    }
}
