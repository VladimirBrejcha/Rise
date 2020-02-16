//
//  ConfirmationPresenter.swift
//  Rise
//
//  Created by Владимир Королев on 07.01.2020.
//  Copyright © 2020 VladimirBrejcha. All rights reserved.
//

import Foundation

final class ConfirmationPresenter: ConfirmationViewOutput {
    private unowned let view: ConfirmationViewInput
    
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

        if PersonalPlanHelper.isConfirmed(for: .yesterday, plan: plan) {
            dismiss = { [weak self] in self?.view.dismiss() }
            return
        }

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
        view.updateDescription(with: descriptionString)
    }
    
    func viewDidAppear() {
        dismiss?()
    }
    
    private var isResheduled: Bool = false
    
    func reshedulePressed() {
        guard let plan = personalPlan else {
            view.dismiss()
            return
        }
        
        guard let resheduledPlan = PersonalPlanHelper.reshedule(plan: plan) else {
            view.dismiss()
            return
        }
        
        isResheduled = true
        
        if (updatePlan.execute(resheduledPlan)) {
            view.showLoadingView(true)
            view.showButtons(false)
            view.updateTitle(with: "Resheduling")
            view.updateDescription(with: "Rise plan is being updated...")
            view.showRescheduleButton(false)
            
            Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { _ in
                self.view.showLoadingView(false)
                self.view.showButtons(true)
                self.view.updateConfirmButtonTitle(with: "Continue")
                self.view.updateDescription(with: "Successfully completed")
            }
        } else {
            view.dismiss()
        }
    }
    
    func confirmPressed() {
        guard let plan = personalPlan else {
            view.dismiss()
            return
        }
        
        if isResheduled {
            view.dismiss()
            return
        }
        
        let confirmedPlan = PersonalPlanHelper.confirm(plan: plan)
        if (updatePlan.execute(confirmedPlan)) {
            view.dismiss()
        } else {
            view.dismiss()
        }
    }
}
