//
//  ChangePlanButtonTableCell.swift
//  Rise
//
//  Created by Владимир Королев on 11.03.2020.
//  Copyright © 2020 VladimirBrejcha. All rights reserved.
//

import UIKit

final class ChangePlanButtonTableCell: UITableViewCell, ConfigurableCell {
    typealias Model = ChangePlanButtonTableCellModel
    
    @IBOutlet private weak var button: Button!
    
    private var buttonHander: (() -> Void)?
    
    @IBAction func buttonTouchUp(_ sender: Button) {
        buttonHander?()
    }
    
    func configure(with model: Model) {
        button.setTitle(model.title, for: .normal)
        button.setTitleColor(Color.redTitle, for: .normal)
        buttonHander = model.action
    }
}
