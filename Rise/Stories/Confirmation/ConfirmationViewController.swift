//
//  ConfirmationViewController.swift
//  Rise
//
//  Created by Владимир Королев on 08.12.2019.
//  Copyright © 2019-2020 VladimirBrejcha. All rights reserved.
//

import UIKit

final class ConfirmationViewController: UIViewController {
    @IBOutlet private var confirmationView: ConfirmationView!
    
    var getPlan: GetPlan! // DI
    var confirmPlan: ConfirmPlan! // DI
    var getDailyTime: GetDailyTime! // DI
    var reshedulePlan: ReshedulePlan! // DI
    
    private var yesterdayPlanToSleepTimeString: String?
    private var descriptionString: String {
        yesterdayPlanToSleepTimeString != nil
            ? "Confirm if you went sleep at the \(yesterdayPlanToSleepTimeString!) o'clock yesterday or reshedule Rise plan to match your current sleep schedule"
            : "Confirm if you went sleep at the planned time yesterday or reshedule Rise plan to match your current sleep schedule"
    }
    
    private var shouldDismissAfterAppear = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        confirmationView.resheduleHandler = { [weak self] in
            guard let self = self else { return }
            do {
                try self.reshedulePlan.execute()
                self.confirmationView.titleText = "Resheduling"
                self.confirmationView.descriptionText = "Rise plan is being updated..."
                Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { _ in
                    self.confirmationView.showRescheduleButton(false)
                    self.confirmationView.showLoadingView(false)
                    self.confirmationView.titleText = "Continue"
                    self.confirmationView.descriptionText = "Successfully completed"
                }
            } catch {
                // todo handle error
                self.dismiss(animated: true)
            }
        }
        
        confirmationView.confirmHandler = { [weak self] in
            do {
                try self?.confirmPlan.execute()
            } catch (let error) {
                // todo handle error
            }
            self?.dismiss(animated: true)
        }

        guard let plan = try? getPlan.execute()
            else {
                shouldDismissAfterAppear = true
                return
        }
        let confirmed = (try? confirmPlan.checkIfConfirmed()) ?? false
        if !confirmed {
            shouldDismissAfterAppear = true
            return
        }
        let yesterday = NoonedDay.yesterday.date
        guard let yesterdayDailyTime = try? getDailyTime.execute(for: yesterday)
            else {
                shouldDismissAfterAppear = true
                return
        }

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        yesterdayPlanToSleepTimeString = dateFormatter.string(from: yesterdayDailyTime.sleep)

        let daysMissed = DateInterval(start: plan.latestConfirmedDay, end: yesterday).durationDays
        if daysMissed == 0 {
            shouldDismissAfterAppear = true
            return
        }
        if daysMissed == 1 {
            confirmationView.titleText = "You did not show up last day"
        } else {
            confirmationView.titleText = "You did not show up previous days"
        }
        confirmationView.descriptionText = descriptionString
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if shouldDismissAfterAppear {
            dismiss(animated: true)
        }
    }
}
