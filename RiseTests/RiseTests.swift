//
//  RiseTests.swift
//  RiseTests
//
//  Created by Vladimir Korolev on 23/05/2019.
//  Copyright © 2019 VladimirBrejcha. All rights reserved.
//

import XCTest
@testable import Rise

class RiseTests: XCTestCase {
    
    var calculator: PersonalTimeCalculator?
    
    override func setUp() {
        super.setUp()
        
        guard let wakeUpDate = Formater.dateFormatter.date(from: "06:00") else { fatalError("cant convert") }
        guard let wentSleepTimeDate = Formater.dateFormatter.date(from: "02:00") else { fatalError("cant convert") }
        
        calculator = PersonalTimeCalculator(wakeUp: wakeUpDate, sleepDuration: 480, wentSleepTime: wentSleepTimeDate, duration: 10)
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testCalculator() {
        
        calculator?.calculate()
        
        XCTAssertEqual(calculator?.result, 24)
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
