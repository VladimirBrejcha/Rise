//
//  ConfirmationPresenter.swift
//  Rise
//
//  Created by Владимир Королев on 07.01.2020.
//  Copyright © 2020 VladimirBrejcha. All rights reserved.
//

import Foundation

final class ConfirmationPresenter: ConfirmationViewOutput {
    private weak var view: ConfirmationViewInput?
    
    private let getPlan: GetPlan
    private let confirmPlan: ConfirmPlan
    private let getDailyTime: GetDailyTime
    private let reshedulePlan: ReshedulePlan
    
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
        confirmPlan: ConfirmPlan,
        getDailyTime: GetDailyTime,
        reshedulePlan: ReshedulePlan
    ) {
        self.view = view
        self.getPlan = getPlan
        self.confirmPlan = confirmPlan
        self.getDailyTime = getDailyTime
        self.reshedulePlan = reshedulePlan
    }
    
    // MARK: - ConfirmationViewOutput -
    func viewDidLoad() {
        guard let view = view else { return }
        guard let plan = try? getPlan.execute()
            else {
                dismiss = { view.dismiss() }
                return
        }
        
        let confirmed = (try? confirmPlan.checkIfConfirmed()) ?? false

        if !confirmed {
            dismiss = { view.dismiss() }
            return
        }
        
        guard let yesterdayDailyTime = try? getDailyTime.execute(for: Date().appending(days: -1)!.noon)
            else {
                dismiss = { view.dismiss() }
                return
        }

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        yesterdayPlanToSleepTimeString = dateFormatter.string(from: yesterdayDailyTime.sleep)

        let daysMissed = DateInterval(start: plan.latestConfirmedDay, end: Date().appending(days: -1)!.noon).durationDays
        
        if daysMissed == 0 {
            dismiss = { view.dismiss() }
            return
        }
        if daysMissed == 1 {
            view.updateTitle(with: "You did not show up last day")
        } else {
            view.updateTitle(with: "You did not show up previous days")
        }
        view.updateDescription(with: descriptionString)
    }
    
    func viewDidAppear() {
        dismiss?()
    }
    
    func reshedulePressed() {
        guard let view = view else { return }
        
        do {
            try reshedulePlan.execute()
            view.updateTitle(with: "Resheduling")
            view.updateDescription(with: "Rise plan is being updated...")
            
            Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { _ in
                view.showRescheduleButton(false)
                view.showLoadingView(false)
                view.updateConfirmButtonTitle(with: "Continue")
                view.updateDescription(with: "Successfully completed")
            }
        } catch {
            // todo handle error
            view.dismiss()
        }
    }
    
    func confirmPressed() {
        do {
            try confirmPlan.execute()
        } catch (let error) {
            
        }
        view?.dismiss()
    }
}
