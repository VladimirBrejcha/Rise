//
//  ChangePlanViewController.swift
//  Rise
//
//  Created by Владимир Королев on 03.01.2020.
//  Copyright © 2020 VladimirBrejcha. All rights reserved.
//

import UIKit

protocol ChangePlanViewInput: AnyObject {
    func setTableView(with dataSource: UITableViewDataSource)
    func reloadTable()
    func reloadItem(at indexPath: IndexPath)
    func reloadItems(at indexPaths: [IndexPath])
    
    func getIndexPath(of cell: UITableViewCell) -> IndexPath?
    
    func dismiss()
}

protocol ChangePlanViewOutput: ViewControllerLifeCycle {
    func close()
    func save()
}

final class ChangePlanViewController:
    UIViewController,
    ChangePlanViewInput,
    UITableViewDelegate
{
    var output: ChangePlanViewOutput!
    
    @IBOutlet private weak var saveButton: Button!
    @IBOutlet private weak var closeButton: UIButton!
    @IBOutlet private weak var tableView: ChangePlanTableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let backgroundView = GradientHelper.makeDefaultStaticGradient(for: view.bounds)
        view.addSubview(backgroundView)
        view.sendSubviewToBack(backgroundView)
        
        tableView.delegate = self
        
        output.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        output.viewWillAppear()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        output.viewDidAppear()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        output.viewWillDisappear()
    }
    
    @IBAction func closeTouchUp(_ sender: UIButton) {
        output.close()
    }
    
    @IBAction func saveTouchUp(_ sender: Button) {
        output.save()
    }
    
    // MARK: - ChangePlanViewInput -
    func setTableView(with dataSource: UITableViewDataSource) {
        tableView.dataSource = dataSource
    }
    
    func reloadItem(at indexPath: IndexPath) {
        DispatchQueue.main.async {
            self.tableView.reloadRows(at: [indexPath], with: .automatic)
        }
    }
    
    func reloadItems(at indexPaths: [IndexPath]) {
        DispatchQueue.main.async {
            self.tableView.reloadRows(at: indexPaths, with: .automatic)
        }
    }
    
    func reloadTable() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func getIndexPath(of cell: UITableViewCell) -> IndexPath? {
        tableView.indexPath(for: cell)
    }
    
    func dismiss() {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - UITableViewDelegate -
    private let cellSpacing: CGFloat = 10
    private let sectionFooter: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0: return 180
        case 3: return 60
        default: return 120
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        section == tableView.numberOfSections - 1
            ? 0
            : cellSpacing
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        sectionFooter
    }
}
