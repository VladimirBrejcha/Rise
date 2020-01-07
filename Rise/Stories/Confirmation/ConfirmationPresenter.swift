//
//  ConfirmationPresenter.swift
//  Rise
//
//  Created by Владимир Королев on 07.01.2020.
//  Copyright © 2020 VladimirBrejcha. All rights reserved.
//

import Foundation

final class ConfirmationPresenter: ConfirmationViewOutput {
    unowned let view: ConfirmationViewInput
    
    private let getPlan: GetPlan
    private let updatePlan: UpdatePlan
    
    private var personalPlan: PersonalPlan? {
        return getPlan.execute()
    }
    
    required init(
        view: ConfirmationViewInput,
        getPlan: GetPlan,
        updatePlan: UpdatePlan
    ) {
        self.view = view
        self.getPlan = getPlan
        self.updatePlan = updatePlan
    }
    
    // MARK: - ConfirmationViewOutput -
    func viewDidLoad() {
        guard let plan = personalPlan else {
            view.dismiss()
            return
        }
        
        if plan.isConfirmedForToday {
            view.dismiss()
            return
        }
        
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let lastConfirmedDay = calendar.startOfDay(for: plan.latestConfirmedDay)
        let components = calendar.dateComponents([.day], from: lastConfirmedDay, to: today)
        guard let yesterday = calendar.date(byAdding: .day, value: -1, to: today) else {
            view.dismiss()
            return
        }

        guard let yesterdayPlanToSleepTime = plan.dailyTimes.first(where:
            { calendar.isDate($0.day, inSameDayAs: yesterday) })?.sleep
            else {
                view.dismiss()
                return
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        let yesterdayPlanToSleepTimeString = dateFormatter.string(from: yesterdayPlanToSleepTime)
        
        if components.day == 1 {
            view.updateTitle(with: "You did not show up last day")
        } else {
            view.updateTitle(with: "You did not show up previous days")
        }
        view.updateDescription(with: "Confirm if you went sleep at the \(yesterdayPlanToSleepTimeString) o'clock yesterday or reshedule Rise plan to match your current sleep schedule")
    }
    
    func reshedulePressed() {
        
    }
    
    func confirmPressed() {
        guard var plan = personalPlan else { return }
        plan.latestConfirmedDay = Date()
        if (updatePlan.execute(plan)) {
            view.dismiss()
        } else {
            view.dismiss()
        }
    }
    
}
