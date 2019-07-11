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
    
    // MARK: Properties
    private lazy var transitionManager = TransitionManager()
    
    // MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        calendar.appearance.titleSelectionColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        calendar.scope = FSCalendarScope.month
        calendar.adjustMonthPosition()
    }
    
    // MARK: Actions
    @IBAction func changeButtonTouch(_ sender: UIButton) {
        transitionManager.makeTransition(to: Identifiers.personal)
    }
    
    func didDismissStorkBySwipe() {
        transitionManager.animateBackground()
    }
    
}

extension ProgressViewController: FSCalendarDelegate {
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        print("123")
    }
}
