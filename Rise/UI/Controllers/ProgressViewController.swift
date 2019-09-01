//
//  NewViewController.swift
//  Rise
//
//  Created by Vladimir Korolev on 05/06/2019.
//  Copyright © 2019 VladimirBrejcha. All rights reserved.
//

import UIKit
import FSCalendar

final class ProgressViewController: UIViewController {
    @IBOutlet weak var calendar: FSCalendar!
    @IBOutlet weak var infomationLabel: UILabel!
    
    // MARK: Properties
    private lazy var transitionManager = TransitionManager()
    
    // MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        calendar.appearance.titleSelectionColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        calendar.scope = FSCalendarScope.month
        calendar.adjustMonthPosition()
        calendar.dataSource = self
        calendar.delegate = self
    }
    
    // MARK: Actions
    @IBAction func changeButtonTouch(_ sender: UIButton) {
        transitionManager.makeTransition(to: Identifiers.personal)
        
        UIView.animate(withDuration: 0.1) {
            sender.transform = CGAffineTransform.identity
        }
    }
    
    @IBAction func buttonTouch(_ sender: UIButton) {
        UIView.animate(withDuration: 0.1,
                       animations: {
                        sender.transform = CGAffineTransform(scaleX: 0.93, y: 0.93)
        })
    }
    @IBAction func touchCancel(_ sender: UIButton) {
        UIView.animate(withDuration: 0.1) {
            sender.transform = CGAffineTransform.identity
        }
    }
    @IBAction func dragOutside(_ sender: UIButton) {
        UIView.animate(withDuration: 0.1) {
            sender.transform = CGAffineTransform.identity
        }
    }
    
    func didDismissStorkBySwipe() {
        transitionManager.animateBackground()
    }
    
    func didDismissByNewScheduleButton(controller: UIViewController) {
        guard let personalTimeVC = controller as? PersonalTimeViewController else { return }
        personalTimeVC.delegate = self
    }
    
}

extension ProgressViewController: FSCalendarDelegate {
}

extension ProgressViewController: PersonalPlanDelegate {
    func newPlanCreated(plan: CalculatedPlan) {
        infomationLabel.text = "Your plan will take \(plan.days) days, about \(plan.minutesPerDay) minutes per day"
    }
}

// начинать по кнопке старт
extension ProgressViewController: FSCalendarDataSource {
    
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        let today = Date()
        let myCalendar = Calendar.current
        let tomorrow = myCalendar.date(byAdding: .day, value: 1, to: today)
        let tomorrow2 = myCalendar.date(byAdding: .day, value: 2, to: today)
        let day = myCalendar.component(.day, from: today)
        let calendarDay = myCalendar.component(.day, from: date as Date)
        
        if day == calendarDay {
            return 0
        } else {
            return 1
        }
    }

}
