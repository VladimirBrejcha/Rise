//
//  NewViewController.swift
//  Rise
//
//  Created by Vladimir Korolev on 05/06/2019.
//  Copyright © 2019 VladimirBrejcha. All rights reserved.
//

import UIKit

final class ProgressViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var infomationLabel: UILabel!
    @IBOutlet weak var progressTableView: UITableView!
    private let progressCellsContent: [(String, CGFloat)] = [("Streak", 0.5), ("Completed", 0.8), ("Closed to sunrise", 0.3)]
    
    // MARK: Properties
    private lazy var transitionManager = TransitionManager()
    
    // MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        progressTableView.layer.cornerRadius = 12
        progressTableView.register(UINib(nibName: "ProgressTableViewCell", bundle: nil),
                           forCellReuseIdentifier: "progressCell")
        progressTableView.delegate = self
        progressTableView.dataSource = self
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

extension ProgressViewController: PersonalPlanDelegate {
    func newPlanCreated(plan: CalculatedPlan) {
        infomationLabel.text = "Your plan will take \(plan.days) days, about \(plan.minutesPerDay) minutes per day"
    }
}

// MARK: TableViewControllerDelegate
extension ProgressViewController {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "progressCell", for: indexPath) as! ProgressTableViewCell
        cell.centerProgressLabel.text = progressCellsContent[indexPath.section].0
        cell.progress = progressCellsContent[indexPath.section].1
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }
}
