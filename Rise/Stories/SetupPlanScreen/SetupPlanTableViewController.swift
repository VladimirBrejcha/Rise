//
//  PersonalTimeViewController.swift
//  Rise
//
//  Created by Vladimir Korolev on 25/05/2019.
//  Copyright © 2019 VladimirBrejcha. All rights reserved.
//

import UIKit
import AnimatedGradientView

protocol SetupPlanViewOutput: ExpandingCellDelegate {
    var personalPlanDelegate: PersonalPlanDelegate? { get set }
    func scheduleTapped()
}

protocol SetupPlanViewInput: class {
    func dismiss()
    func showBanner()
    var isScheduleButtonEnabled: Bool { get set }
}

final class SetupPlanTableViewController: UITableViewController, SetupPlanViewInput {
    var output: SetupPlanViewOutput?
    
    var isScheduleButtonEnabled: Bool = false { willSet { createScheduleButton.isEnabled = newValue } }
    
    private var gradientManager: GradientManager? { return GradientManager(frame: view.bounds) }
    private var transitionManager = TransitionManager()
    private var bannerManager: BannerManager? { return BannerManager(title: "Saved", style: .success) }
    
    private let CellID = "expandingCell"
    private let cellNibName = "ExpandingCell"
    private var cellNib: UINib { return UINib(nibName: cellNibName, bundle: nil) }
    private var previouslySelectedCell: ExpandingCell?
    
    @IBOutlet weak var createScheduleButton: UIButton!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        output = SetupPlanPresenter(view: self)
        tableView.register(cellNib, forCellReuseIdentifier: CellID)
        
        createBackground()
    }
    
    private func createBackground() {
        tableView.backgroundView = gradientManager?.createStaticGradient(colors: [#colorLiteral(red: 0.1254607141, green: 0.1326543987, blue: 0.2668849528, alpha: 1), #colorLiteral(red: 0.34746629, green: 0.1312789619, blue: 0.2091784477, alpha: 1)],
                                                                         direction: .up,
                                                                         alpha: 1)
    }
    
    @IBAction func scheduleTapped(_ sender: UIButton) { output?.scheduleTapped() }
    
    // MARK: - SetupPlanViewInput
    func dismiss() { transitionManager.dismiss(self) }
    func showBanner() { bannerManager?.banner.show() } // TODO: use my solution insted
    
    // MARK: - TableView methods
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        // Get the correct height if the cell is a ExpandingCell.
        guard let cell = tableView.cellForRow(at: indexPath) as? ExpandingCell else { return super.tableView(tableView, heightForRowAt: indexPath) }
        return cell.pickerHeight()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? ExpandingCell else { return }
        if previouslySelectedCell != nil && cell.expanded == false && previouslySelectedCell!.expanded {
            previouslySelectedCell?.selectedInTableView(tableView) } // telling cell to hide if other cell has been selected
        cell.selectedInTableView(tableView)
        previouslySelectedCell = cell
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        super.tableView(tableView, cellForRowAt: indexPath)
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CellID) as? ExpandingCell else { return UITableViewCell() }
        
        cell.delegate = output
        cell.tag = indexPath.section
        
        switch indexPath.section {
        case 0, 2:
            cell.leftLabel.text = "Choose time:"
            cell.createPicker(.datePicker)
        case 1:
            cell.leftLabel.text = "Choose hours:"
            let pickerDataModel = PickerDataModel(numberOfRows: DataForPicker.hoursArray.count,
                                                  titleForRowArray: DataForPicker.hoursArray, defaultRow: 2)
            cell.createPicker(.pickerView, model: pickerDataModel)
        case 3:
            cell.leftLabel.text = "Choose duration:"
            let pickerDataModel = PickerDataModel(numberOfRows: DataForPicker.daysArray.count,
                                                  titleForRowArray: DataForPicker.daysArray, defaultRow: 2)
            cell.createPicker(.pickerView, model: pickerDataModel)
        default: print("error") }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let headerView = view as? UITableViewHeaderFooterView { headerView.textLabel?.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.6) }
    }
}

