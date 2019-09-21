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
    @IBOutlet weak var infoTableView: UITableView!
    @IBOutlet weak var progressTableView: UITableView!
    private let progressCellsContent: [(String, CGFloat)] = [("Streak", 0.5)]
    
    // MARK: Properties
    private lazy var transitionManager = TransitionManager()
    
    // MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        infoTableView.register(UINib(nibName: "PlanInfoTableViewCell", bundle: nil), forCellReuseIdentifier: "infoCell")
        progressTableView.register(UINib(nibName: "ProgressTableViewCell", bundle: nil),
                           forCellReuseIdentifier: "progressCell")
        infoTableView.delegate = self
        infoTableView.dataSource = self
        progressTableView.delegate = self
        progressTableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
//        infoTableView.estimatedRowHeight = 100
//        infoTableView.rowHeight = UITableView.automaticDimension
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
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableView == progressTableView ? 1 : 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == progressTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "progressCell", for: indexPath) as! ProgressTableViewCell
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "infoCell", for: indexPath) as! PlanInfoTableViewCell
            return cell
        }
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if tableView == infoTableView {
        return 5
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if tableView == infoTableView {
        return 5
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView == progressTableView ? tableView.frame.size.height : tableView.frame.size.height / 4 - 2.5
    }
}
