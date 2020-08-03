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
        let yesterday = NoonedDay.yesterday.date
        let daysMissed = DateInterval(start: plan.latestConfirmedDay, end: yesterday).durationDays
        guard
            let yesterdayDailyTime = try? getDailyTime(for: yesterday),
            daysMissed > 0,
            !confirmed  else {
                shouldDismissAfterAppear = true
                return
        }
        
        confirmationView.titleText = daysMissed == 1
            ? Model.Title.missedOneDay
            : Model.Title.missedMultipleDays
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        let plannedTime = dateFormatter.string(from: yesterdayDailyTime.sleep)
        confirmationView.descriptionText = Model.Description.withPlannedTime(plannedTime)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if shouldDismissAfterAppear {
            dismiss(animated: true)
        }
    }
    
    // MARK: - Model -
    private struct Model {
        struct Description {
            static let updating = "Rise plan is being updated..."
            static let completed = "Successfully completed"
            static func withPlannedTime(_ time: String) -> String {
                "Confirm if you went sleep at the \(time) o'clock yesterday or reshedule Rise plan to match your current sleep schedule"
            }
        }
        struct Title {
            static let missedOneDay = "You did not show up last day"
            static let missedMultipleDays = "You did not show up previous days"
            static let resheduling = "Resheduling"
            static let `continue` = "Continue"
        }
    }
}
