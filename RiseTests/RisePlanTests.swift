//
//  RiseTests.swift
//  RiseTests
//
//  Created by Владимир Королев on 11.01.2020.
//  Copyright © 2020 VladimirBrejcha. All rights reserved.
//

import XCTest
@testable import Rise

class RisePlanTests: XCTestCase {
    
    var risePlan: PersonalPlan?
    var calendar: Calendar {
        return Calendar.current
    }

    override func setUp() {
        let wakeUpTimeDateComponents = DateComponents(
            calendar: calendar,
            hour: 7,
            minute: 0
        )
        let wakeUpTime = calendar.date(from: wakeUpTimeDateComponents)
        
        let wentSleepTimeDateComponents = DateComponents(
            calendar: calendar,
            hour: 23,
            minute: 50,
            second: 0
        )
        
        let wentSleepTime = calendar.date(from: wentSleepTimeDateComponents)
        
        risePlan = PersonalPlan(sleepDuration: 600,
                                wakeUpTime: wakeUpTime!,
                                planDuration: 30,
                                wentSleepTime: wentSleepTime!)
    }

    override func tearDown() { }
    
    // MARK: - Tests -
    func testfinalSleepTime() {
        super.tearDown()
        
        guard let plan = risePlan
            else {
                XCTAssert(false)
                return
        }
        
        let wakeUpTime = plan.finalWakeTime
        
        guard let finalSleepTime = calendar.date(byAdding: .second,
                                                 value: -Int(plan.sleepDuration),
                                                 to: wakeUpTime)
            else {
                XCTAssert(false)
                return
        }
        
        let componentsOfFinalSleepTime = calendar.dateComponents([.hour, .minute, .second], from: plan.finalSleepTime)
        let componentsOfCorrectFinalSleepTime = calendar.dateComponents([.hour, .minute, .second], from: finalSleepTime)
        
        XCTAssertEqual(componentsOfFinalSleepTime, componentsOfCorrectFinalSleepTime)
    }
    
//    func testPlanDailyTimes() {
//        super.tearDown()
//        
//        guard let plan = risePlan
//            else {
//                XCTAssert(false)
//                return
//        }
//
//        let dailyShiftTime = Int(plan.sleepDuration) / plan.planDuration
//
//        plan.dailyTimes.forEach { dailyTime in
//            guard let daysBetweenPlanEndAndDailyTime = calendar.dateComponents([.day],
//                                                                               from: plan.planEndDate,
//                                                                               to: dailyTime.day).day
//                else {
//                    XCTAssert(false)
//                    return
//            }
//
//            calendar.dateInterval(of: <#T##Calendar.Component#>, for: <#T##Date#>)
//
//            let shiftForToday = daysBetweenPlanEndAndDailyTime * dailyShiftTime
//
//            let wakeUpTime = plan.finalWakeTime.addingTimeInterval(Double(shiftForToday))
//            let sleepTime = plan.finalSleepTime.addingTimeInterval(Double(shiftForToday))
//
//            let wakeUpTimeComponents = calendar.component(.minute, from: dailyTime.wake)
//            let sleepTimeComponents = calendar.component(.minute, from: dailyTime.sleep)
//
//            let correctWakeUpTimeComponents = calendar.component(.minute, from: wakeUpTime)
//            let correctSleepTimeComponents = calendar.component(.minute, from: sleepTime)
//
//            XCTAssertEqual(wakeUpTimeComponents, correctWakeUpTimeComponents)
//            XCTAssertEqual(sleepTimeComponents, correctSleepTimeComponents)
//        }
//    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }

}
