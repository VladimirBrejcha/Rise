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
        
        risePlan = PersonalPlanHelper.makePlan(
            sleepDurationMin: 600,
            wakeUpTime: wakeUpTime!,
            planDuration: 30,
            wentSleepTime: wentSleepTime!
        )
    }

    override func tearDown() { }
    
    // MARK: - Tests -
    func testSleepTime() {
        super.tearDown()
        
        guard let plan = risePlan
            else {
                XCTAssert(false)
                return
        }
        
        let sleepTime = PersonalPlanHelper.getPlannedSleepTime(for: plan)
        
        XCTAssertEqual(plan.wakeTime.timeIntervalSince(sleepTime), plan.sleepDurationSec)
    }
    
    func testPlanDuration() {
        super.tearDown()
        
        guard let plan = risePlan
            else {
                XCTAssert(false)
                return
        }
        
        let planDuration = PersonalPlanHelper.getPlanDuration(for: plan)
        
        guard let daysBetweenPlanStartAndEnd = calendar.dateComponents([.day],
                                                                       from: plan.dateInterval.start,
                                                                       to: plan.dateInterval.end).day
            else {
                XCTAssert(false)
                return
        }
        
        XCTAssertEqual(planDuration, daysBetweenPlanStartAndEnd)
    }
    
    func testDailyTime() {
        super.tearDown()
        
        guard let plan = risePlan
            else {
                XCTAssert(false)
                return
        }
        
        let planDuration = PersonalPlanHelper.getPlanDuration(for: plan)
        let dailyShiftSec = plan.dailyShiftMin * 60
        
        for dayNumber in 0...planDuration {
            guard let previousPlanDayDate = plan.dateInterval.start.appending(days: dayNumber - 1)
                else {
                    XCTAssert(false)
                    return
            }
            guard let thisPlanDayDate = plan.dateInterval.start.appending(days: dayNumber)
                else {
                    XCTAssert(false)
                    return
            }
            guard let nextPlanDayDate = plan.dateInterval.start.appending(days: dayNumber + 1)
                else {
                    XCTAssert(false)
                    return
            }
            guard let thisDayDailyTime = PersonalPlanHelper.getDailyTime(for: plan, and: thisPlanDayDate)
                else {
                    XCTAssert(false)
                    return
            }
            
            if dayNumber == 0 {
                XCTAssert(PersonalPlanHelper.getDailyTime(for: plan, and: previousPlanDayDate) == nil)
                
                guard let nextDayDailyTime = PersonalPlanHelper.getDailyTime(for: plan, and: nextPlanDayDate)
                    else {
                        XCTAssert(false)
                        return
                }
                XCTAssertEqual(nextDayDailyTime.day, thisDayDailyTime.day.appending(days: 1))
                XCTAssertEqual(thisDayDailyTime.wake.addingTimeInterval(TimeInterval(dailyShiftSec)), nextDayDailyTime.wake)
                XCTAssertEqual(thisDayDailyTime.sleep.addingTimeInterval(TimeInterval(dailyShiftSec)), nextDayDailyTime.sleep)
                
            } else if dayNumber == planDuration {
                XCTAssertEqual(PersonalPlanHelper.getDailyTime(for: plan, and: thisPlanDayDate)?.wake,
                               PersonalPlanHelper.getDailyTime(for: plan, and: nextPlanDayDate)?.wake)
                XCTAssertEqual(PersonalPlanHelper.getDailyTime(for: plan, and: thisPlanDayDate)?.sleep,
                               PersonalPlanHelper.getDailyTime(for: plan, and: nextPlanDayDate)?.sleep)
                
                guard let previuosDayDailyTime = PersonalPlanHelper.getDailyTime(for: plan, and: previousPlanDayDate)
                    else {
                        XCTAssert(false)
                        return
                }
                XCTAssertEqual(previuosDayDailyTime.day, thisDayDailyTime.day.appending(days: -1))
                XCTAssertEqual(previuosDayDailyTime.wake.addingTimeInterval(TimeInterval(dailyShiftSec)), thisDayDailyTime.wake)
                XCTAssertEqual(previuosDayDailyTime.sleep.addingTimeInterval(TimeInterval(dailyShiftSec)), thisDayDailyTime.sleep)
                
            } else {
                guard let nextDayDailyTime = PersonalPlanHelper.getDailyTime(for: plan, and: nextPlanDayDate)
                    else {
                        XCTAssert(false)
                        return
                }
                XCTAssertEqual(nextDayDailyTime.day, thisDayDailyTime.day.appending(days: 1))
                XCTAssertEqual(thisDayDailyTime.wake.addingTimeInterval(TimeInterval(dailyShiftSec)), nextDayDailyTime.wake)
                XCTAssertEqual(thisDayDailyTime.sleep.addingTimeInterval(TimeInterval(dailyShiftSec)), nextDayDailyTime.sleep)
                
                guard let previuosDayDailyTime = PersonalPlanHelper.getDailyTime(for: plan, and: previousPlanDayDate)
                    else {
                        XCTAssert(false)
                        return
                }
                XCTAssertEqual(previuosDayDailyTime.day, thisDayDailyTime.day.appending(days: -1))
                XCTAssertEqual(previuosDayDailyTime.wake.addingTimeInterval(TimeInterval(dailyShiftSec)), thisDayDailyTime.wake)
                XCTAssertEqual(previuosDayDailyTime.sleep.addingTimeInterval(TimeInterval(dailyShiftSec)), thisDayDailyTime.sleep)
            }
        }
    }
    
    func testChangePlan() {
        super.tearDown()
        
        guard var plan = risePlan
            else {
                XCTAssert(false)
                return
        }
        
        let planDuration = PersonalPlanHelper.getPlanDuration(for: plan)
        
        guard let fakePlanStartDay = plan.dateInterval.start.appending(days: -planDuration)
            else {
                XCTAssert(false)
                return
        }
        
        guard let fakePlanEndDay = plan.dateInterval.end.appending(days: -planDuration)
            else {
                XCTAssert(false)
                return
        }
        
        plan.dateInterval = DateInterval(start: fakePlanStartDay, end: fakePlanEndDay)
        
        for day in 0...planDuration {
            guard let confirmedDay = plan.dateInterval.start.appending(days: day)
                else {
                    XCTAssert(false)
                    return
            }
            
            plan.latestConfirmedDay = confirmedDay
            
            guard let changedPlan = PersonalPlanHelper.reshedule(plan: plan)
                else {
                    XCTAssert(false)
                    return
            }
            
            let today = Date()
            guard let yesterday = today.appending(days: -1)
                else {
                    XCTAssert(false)
                    return
            }
            // check if changedPlan lastestConfirmedDay set to yesterday
            XCTAssert(calendar.isDate(yesterday, inSameDayAs: changedPlan.latestConfirmedDay))
            
            guard let missedDays = calendar.dateComponents([.day],
                                                           from: yesterday,
                                                           to: plan.latestConfirmedDay).day
                else {
                    XCTAssert(false)
                    return
            }
            
            if missedDays <= 0 {
                XCTAssertEqual(plan.dateInterval, changedPlan.dateInterval)
            }
            
            if missedDays > 0 {
                // check if daysMissed calculated correctly
                XCTAssertEqual(plan.daysMissed + missedDays, changedPlan.daysMissed)
                
                let changedPlanEndDay = changedPlan.dateInterval.end
                guard let neededPlanEndDay = plan.dateInterval.end.appending(days: missedDays)
                    else {
                        XCTAssert(false)
                        return
                }
                // check if planEnd day calculated correctly
                XCTAssert(calendar.isDate(changedPlanEndDay, inSameDayAs: neededPlanEndDay))
            }
        }
    }
}
