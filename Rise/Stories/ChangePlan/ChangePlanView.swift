//
//  ChangePlanView.swift
//  Rise
//
//  Created by Владимир Королев on 17.08.2020.
//  Copyright © 2020 VladimirBrejcha. All rights reserved.
//

import UIKit

final class ChangePlanView: UIView, BackgroundSettable {
    @IBOutlet private weak var changePlanTableView: ChangePlanTableView!
    
    struct Model {
        let tableViewDelegate: UITableViewDelegate
        let tableViewDataSource: UITableViewDataSource
        let closeHandler: () -> Void
        let saveHandler: () -> Void
    }
    var model: Model? {
        didSet {
            if let model = model {
                changePlanTableView.delegate = model.tableViewDelegate
                changePlanTableView.dataSource = model.tableViewDataSource
            }
        }
    }
    
    @IBAction private func closeTouchUp(_ sender: UIButton) {
        model?.closeHandler()
    }
    
    @IBAction private func saveTouchUp(_ sender: Button) {
        model?.saveHandler()
    }
    
    func getIndexPath(of cell: UITableViewCell) -> IndexPath? {
        changePlanTableView.indexPath(for: cell)
    }
}
