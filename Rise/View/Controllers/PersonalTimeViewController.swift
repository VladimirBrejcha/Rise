//
//  PersonalTimeViewController.swift
//  Rise
//
//  Created by Vladimir Korolev on 25/05/2019.
//  Copyright © 2019 VladimirBrejcha. All rights reserved.
//

import UIKit
import AnimatedGradientView

final class PersonalTimeViewController: UITableViewController {
    
    // MARK: Properties
    private var previouslySelectedCell: ExpandingCell?
    private var gradientManager: GradientManager?
    private var personalTimeModel = PersonalTimeModel()
    private let notificationCenter: NotificationCenter = .default
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: Cell.nibName, bundle: nil),
                           forCellReuseIdentifier: Cell.identifier)
        
        notificationCenter.addObserver(self,
                                       selector: #selector(updateModel),
                                       name: .pickerValueChanged,
                                       object: nil)
        
        createBackground()
    }
    
    // MARK: UISetup Methods
    private func createBackground() {
        gradientManager = GradientManager(frame: view.bounds)
        tableView.backgroundView = gradientManager?.createStaticGradient(colors: [#colorLiteral(red: 0.0862745098, green: 0.07450980392, blue: 0.1568627451, alpha: 1), #colorLiteral(red: 0.4588235294, green: 0.168627451, blue: 0.2705882353, alpha: 1)],
                                                                         direction: .up,
                                                                         alpha: 0.5)
    }
    
    // MARK: Actions
    @IBAction func scheduleTapped(_ sender: UIButton) {
        
    }
    
    // MARK: TableView methods
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        // Get the correct height if the cell is a DatePickerCell.
        guard let cell = tableView.cellForRow(at: indexPath) as? ExpandingCell else {
            return super.tableView(tableView, heightForRowAt: indexPath)
        }
        
        return cell.pickerHeight()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? ExpandingCell else { return }
        
        if previouslySelectedCell != nil
            && cell.expanded == false
            && previouslySelectedCell!.expanded {
            
            previouslySelectedCell?.selectedInTableView(tableView) // telling cell to hide if other cell has been selected
            
        }
        
        cell.selectedInTableView(tableView)
        
        previouslySelectedCell = cell
        
    }
    
    @objc func updateModel() {
        
        guard let cell = tableView.cellForRow(at: tableView.indexPathForSelectedRow!) as? ExpandingCell  else { fatalError("cell wasnt find") }
        guard let pickedValue = cell.pickedValue  else { fatalError("pickedValue is nil") }
        
        switch cell.tag {
        case 0:
            personalTimeModel.preferedWakeUpTime = pickedValue
        case 1:
            personalTimeModel.preferedSleepDuration = pickedValue
        case 2:
            personalTimeModel.timeWentSleep = pickedValue
        case 3:
            personalTimeModel.duration = pickedValue
        default:
            fatalError("cell with this tag doent exists")
        }
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        super.tableView(tableView, cellForRowAt: indexPath)
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Cell.identifier) as? ExpandingCell else {
            return UITableViewCell()
        }
        
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
            
        default:
            print("error")
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let headerView = view as? UITableViewHeaderFooterView {
            headerView.textLabel?.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.6)
        }
    }
    
}
