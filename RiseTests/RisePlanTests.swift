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
        print(risePlan)
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testfinalSleepTime() {
        XCTAssert(true)
    }

    func testExample() {
        super.tearDown()
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }

}
