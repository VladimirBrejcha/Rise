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
    private var gradientManager: GradientManager? //is it stealing my memory?

    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: Cell.nibName, bundle: nil),
                           forCellReuseIdentifier: Cell.identifier)
        
        createBackground()
    }
    
    // MARK: UISetup Methods
    private func createBackground() {
        gradientManager = GradientManager(frame: view.bounds)
        tableView.backgroundView = gradientManager?.createStaticGradient(colors: [#colorLiteral(red: 0.0862745098, green: 0.07450980392, blue: 0.1568627451, alpha: 1), #colorLiteral(red: 0.4588235294, green: 0.168627451, blue: 0.2705882353, alpha: 1)],
                                                                         direction: .up,
                                                                         alpha: 0.5)
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
        // Deselect automatically if the cell is a DatePickerCell.
        guard let cell = tableView.cellForRow(at: indexPath) as? ExpandingCell else { return }

        if previouslySelectedCell != nil && cell.expanded == false && previouslySelectedCell!.expanded {
            previouslySelectedCell?.selectedInTableView(tableView)
        }

        cell.selectedInTableView(tableView)

        self.tableView.deselectRow(at: indexPath, animated: true)

        previouslySelectedCell = cell
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        super.tableView(tableView, cellForRowAt: indexPath)

        guard let cell = tableView.dequeueReusableCell(withIdentifier: Cell.identifier) as? ExpandingCell else {
            return UITableViewCell()
        }

        switch indexPath.section {
        case 0, 2:
            cell.leftLabel.text = "Choose time:"
            cell.createPicker(.datePicker)
            
        case 1:
            cell.leftLabel.text = "Choose hours:"
            let pickerDataModel = PickerDataModel(numberOfRows: DataForPicker.hoursArray.count,
                                                  titleForRowArray: DataForPicker.hoursArray)
            cell.createPicker(.pickerView, model: pickerDataModel)
            
        case 3:
            cell.leftLabel.text = "Choose options:"
            let pickerDataModel = PickerDataModel(numberOfRows: DataForPicker.daysArray.count,
                                                  titleForRowArray: DataForPicker.daysArray)
            cell.createPicker(.pickerView, model: pickerDataModel)
            
        default:
            print("error")
        }
        return cell
    }
}
