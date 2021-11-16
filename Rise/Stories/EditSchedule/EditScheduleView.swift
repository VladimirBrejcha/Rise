//
//  EditScheduleView.swift
//  Rise
//
//  Created by Vladimir Korolev on 17.08.2020.
//  Copyright © 2020 VladimirBrejcha. All rights reserved.
//

import UIKit

final class EditScheduleView: UIView {
    @IBOutlet private weak var editScheduleTableView: EditScheduleTableView!
    
    struct Handlers {
        let close: () -> Void
        let save: () -> Void
    }
    var handlers: Handlers?

    func configure(dataSource: UITableViewDataSource, delegate: UITableViewDelegate, handlers: Handlers) {
        editScheduleTableView.delegate = delegate
        editScheduleTableView.dataSource = dataSource
        self.handlers = handlers
    }
    
    @IBAction private func closeTouchUp(_ sender: UIButton) {
        handlers?.close()
    }
    
    @IBAction private func saveTouchUp(_ sender: Button) {
        handlers?.save()
    }
    
    func getIndexPath(of cell: UITableViewCell) -> IndexPath? {
        editScheduleTableView.indexPath(for: cell)
    }
}