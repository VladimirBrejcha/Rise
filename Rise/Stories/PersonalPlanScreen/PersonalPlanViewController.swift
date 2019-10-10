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

protocol PersonalPlanViewInput: class {
    func updateProgressView(with progress: Double, maxProgress: String)
    func updatePlanInfo(with info: [String])
    func showLoading()
    func hideLoading()
    func showPlanDoesntExistInfo()
    func hidePlanDoesntExistInfo()
}

protocol PersonalPlanViewOutput: PersonalPlanDelegate {
    func changeButtonPressed()
}

class PersonalPlanViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, PersonalPlanViewInput {
    var output: PersonalPlanViewOutput!
    
    @IBOutlet weak var planButton: UIButton!
    @IBOutlet weak var infomationLabel: UILabel!
    
    @IBOutlet weak var infoTableView: UITableView!
    @IBOutlet weak var progressTableView: UITableView!
    
    @IBOutlet weak var mainContainerView: UIView!
    @IBOutlet weak var loadingView: LoadingView!
    
    private var progressCellMaxValue: String?
    private var progressCellValue: Double = 0.0
    private let infoCellImageArray: [UIImage] = [#imageLiteral(resourceName: "Clock 2"), #imageLiteral(resourceName: "wakeup"), #imageLiteral(resourceName: "fallasleep"), #imageLiteral(resourceName: "sun")]
    private var infoCellLabelTextArray: [String]?
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        output = PersonalPlanPresenter(view: self)
        
        configureTableView(tableView: infoTableView, info: infoTableViewInfo)
        configureTableView(tableView: progressTableView, info: progressTableViewInfo)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loadingView.setupAnimationLayer()
        showPlanDoesntExistInfo()
    }
    
    private func configureTableView(tableView: UITableView, info: (nib: UINib, cellID: String)) {
        tableView.register(info.nib, forCellReuseIdentifier: info.cellID)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    // MARK: - PersonalPlanViewInput
    func updatePlanInfo(with info: [String]) {
        infoCellLabelTextArray = info
        infoTableView.reloadData()
    }
    
    func updateProgressView(with progress: Double, maxProgress: String) {
        progressCellValue = progress
        progressCellMaxValue = maxProgress
        progressTableView.reloadData()
    }
    
    func showPlanDoesntExistInfo() {
        loadingView.showInfo(with: "You don't have sleep plan yet, go and create one!")
    }
    
    func hidePlanDoesntExistInfo() {
        loadingView.hideInfo()
    }
    
    func showLoading() {
        loadingView.showLoading()
    }
    
    func hideLoading() {
        loadingView.hideLoading {
            UIView.animate(withDuration: 0.6, delay: 0, options: .allowUserInteraction, animations: {
                self.mainContainerView.alpha = 1
            })
        }
    }
}

// MARK: - TableViewControllerDataSource
extension PersonalPlanViewController {
    func numberOfSections(in tableView: UITableView) -> Int { return 1 }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { return tableView == progressTableView ? 1 : 4 }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == progressTableView
        { let cell = tableView.dequeueReusableCell(withIdentifier: progressTableViewInfo.cellID, for: indexPath) as! ProgressTableViewCell
            cell.centerProgressLabel.text = "Perfomance"
            cell.startProgressLabel.text = "0"
            cell.endProgressLabel.text = progressCellMaxValue
            cell.progress = CGFloat(progressCellValue)
            return cell }
        else
        { let cell = tableView.dequeueReusableCell(withIdentifier: infoTableViewInfo.cellID, for: indexPath) as! PlanInfoTableViewCell
            cell.infoImageView.image = infoCellImageArray[indexPath.row]
            cell.infoLabel.text = infoCellLabelTextArray?[indexPath.row]
            return cell }
    }
}

// MARK: - TableViewControllerDelegate
extension PersonalPlanViewController {
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat { return tableView == infoTableView ? 0 : 1 }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat { return tableView == infoTableView ? 0 : 1 }
    
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
