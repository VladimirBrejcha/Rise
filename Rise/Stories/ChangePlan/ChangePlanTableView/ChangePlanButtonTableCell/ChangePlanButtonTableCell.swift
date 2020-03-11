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
        button.setTitleColor(#colorLiteral(red: 0.9137254902, green: 0.3764705882, blue: 0.4745098039, alpha: 1), for: .normal)
        buttonHander = model.action
    }
}
