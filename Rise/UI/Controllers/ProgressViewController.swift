//
//  NewViewController.swift
//  Rise
//
//  Created by Vladimir Korolev on 05/06/2019.
//  Copyright © 2019 VladimirBrejcha. All rights reserved.
//

import UIKit

fileprivate let infoTableViewInfo = (nib: UINib(nibName: "PlanInfoTableViewCell", bundle: nil), cellID: "infoCell")
fileprivate let progressTableViewInfo = (nib: UINib(nibName: "ProgressTableViewCell", bundle: nil), cellID: "progressCell")

final class ProgressViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, PersonalPlanDelegate {
    
    @IBOutlet weak var infomationLabel: UILabel!
    @IBOutlet weak var infoTableView: UITableView!
    @IBOutlet weak var progressTableView: UITableView!
    private let progressCellsContent: [(String, CGFloat)] = [("Streak", 0.5)]
    private let infoCellsContent: [(UIImage, String)] = [( #imageLiteral(resourceName: "Clock") , "8 hours of sleep daily"), ( #imageLiteral(resourceName: "wakeup") , "Will wake up at 07:69"),
                                                         ( #imageLiteral(resourceName: "fallasleep") , "Will sleep at 22:13"), ( #imageLiteral(resourceName: "sun") , "Synchronksed with sunrise")]
    
    private lazy var transitionManager = TransitionManager()
    
    // MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTableView(tableView: infoTableView, info: infoTableViewInfo)
        configureTableView(tableView: progressTableView, info: progressTableViewInfo)
    }
    
    private func configureTableView(tableView: UITableView, info: (nib: UINib, cellID: String)) {
        tableView.register(info.nib, forCellReuseIdentifier: info.cellID)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    // MARK: Actions
    @IBAction func changeButtonTouch(_ sender: UIButton) {
        transitionManager.makeTransition(to: Identifiers.personal)
        
        UIView.animate(withDuration: 0.1) { sender.transform = CGAffineTransform.identity }
    }
    
    @IBAction func buttonTouch(_ sender: UIButton) {
        UIView.animate(withDuration: 0.1, animations: { sender.transform = CGAffineTransform(scaleX: 0.93, y: 0.93) })
    }
    
    @IBAction func touchCancel(_ sender: UIButton) {
        UIView.animate(withDuration: 0.1) { sender.transform = CGAffineTransform.identity }
    }
    
    @IBAction func dragOutside(_ sender: UIButton) {
        UIView.animate(withDuration: 0.1) { sender.transform = CGAffineTransform.identity }
    }
    
    func didDismissStorkBySwipe() { transitionManager.animateBackground() }
    
    func didDismissByNewScheduleButton(controller: UIViewController) {
        guard let personalTimeVC = controller as? PersonalTimeViewController else { return }
        personalTimeVC.delegate = self
    }
}

// MARK: - PersonalPlanDelegate
extension ProgressViewController {
    func newPlanCreated(plan: CalculatedPlan) {
        infomationLabel.text = "Your plan will take \(plan.days) days, about \(plan.minutesPerDay) minutes per day"
    }
}

// MARK: - TableViewControllerDataSource
extension ProgressViewController {
    func numberOfSections(in tableView: UITableView) -> Int { return 1 }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { return tableView == progressTableView ? 1 : 4 }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == progressTableView
        { let cell = tableView.dequeueReusableCell(withIdentifier: progressTableViewInfo.cellID, for: indexPath) as! ProgressTableViewCell
            return cell }
        else
        { let cell = tableView.dequeueReusableCell(withIdentifier: infoTableViewInfo.cellID, for: indexPath) as! PlanInfoTableViewCell
            cell.infoImageView.image = infoCellsContent[indexPath.row].0
            cell.infoLabel.text = infoCellsContent[indexPath.row].1
            return cell }
    }
}

// MARK: - TableViewControllerDelegate
extension ProgressViewController {
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat { return tableView == infoTableView ? 5 : 0 }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat { return tableView == infoTableView ? 5 : 0 }
    
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView == progressTableView ? tableView.frame.size.height : tableView.frame.size.height / 4 - 2.5
    }
}
