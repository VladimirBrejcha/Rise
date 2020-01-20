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
    
    private var yesterdayPlanToSleepTimeString: String?
    private var descriptionString: String {
        yesterdayPlanToSleepTimeString != nil
            ? "Confirm if you went sleep at the \(yesterdayPlanToSleepTimeString!) o'clock yesterday or reshedule Rise plan to match your current sleep schedule"
            : "Confirm if you went sleep at the planned time yesterday or reshedule Rise plan to match your current sleep schedule"
    }
    
    private var pickedTime: Date?
    private var isResheduling: Bool = false
    
    private var dismiss: (() -> Void)?
    
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
        guard let plan = personalPlan
            else {
                dismiss = { [weak self] in self?.view.dismiss() }
                return
        }

        if PersonalPlanHelper.checkIfConfirmedForToday(plan: plan) {
            dismiss = { [weak self] in self?.view.dismiss() }
            return
        }

        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        
        guard let yesterday = calendar.date(byAdding: .day, value: -1, to: today)
            else {
                dismiss = { [weak self] in self?.view.dismiss() }
                return
        }
        
        guard let yesterdayPlanToSleepTime = PersonalPlanHelper.getDailyTime(for: plan, and:today)?.sleep
            else {
                dismiss = { [weak self] in self?.view.dismiss() }
                return
        }

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        yesterdayPlanToSleepTimeString = dateFormatter.string(from: yesterdayPlanToSleepTime)

        let lastConfirmedDay = calendar.startOfDay(for: plan.latestConfirmedDay)
        let components = calendar.dateComponents([.day], from: lastConfirmedDay, to: yesterday)
        
        if components.day == 0 {
            dismiss = { [weak self] in self?.view.dismiss() }
            return
        }
        if components.day == 1 {
            view.updateTitle(with: "You did not show up last day")
        } else {
            view.updateTitle(with: "You did not show up previous days")
        }
        view.setDatePicker(value: yesterdayPlanToSleepTime)
        view.updateDescription(with: descriptionString)
    }
    
    func viewDidAppear() {
        dismiss?()
    }
    
    func reshedulePressed() {
        isResheduling.toggle()
        view.showDatePicker(isResheduling)
        view.updateResheduleTitle(with: isResheduling ? "Cancel" : "Reshedule")
        view.enableConfirmButton(!isResheduling)
        
        view.updateDescription(
            with:
            isResheduling
                ? "Let's update Rise plan to match your current sleep schedule! Enter the time you went sleep last time"
                : descriptionString
        )
    }
    
    func confirmPressed() {
        guard var plan = personalPlan else { return }
        
        if isResheduling {
            
        }
        
        plan.latestConfirmedDay = Date()
        if (updatePlan.execute(plan)) {
            view.dismiss()
        } else {
            view.dismiss()
        }
    }
    
    func timeValueUpdated(_ value: Date) {
        view.enableConfirmButton(true)
        pickedTime = value
    }
}
