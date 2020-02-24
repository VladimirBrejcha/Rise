//
//  PlanInfoTableViewCell.swift
//  Rise
//
//  Created by Владимир Королев on 21/09/2019.
//  Copyright © 2019 VladimirBrejcha. All rights reserved.
//

import UIKit

final class PlanInfoTableViewCell: UITableViewCell, ConfigurableCell {
    typealias Model = PlanInfoTableCellModel
    
    @IBOutlet private weak var infoImageView: UIImageView!
    @IBOutlet private weak var infoLabel: UILabel!
    
    func configure(with model: PlanInfoTableCellModel) {
        if !model.imageName.isEmpty {
            infoImageView.image = UIImage(named: model.imageName)
        }
        infoLabel.text = model.text
    }
}
