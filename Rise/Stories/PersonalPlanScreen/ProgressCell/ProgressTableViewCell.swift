//
//  ProgressTableViewCell.swift
//  Rise
//
//  Created by Владимир Королев on 11/09/2019.
//  Copyright © 2019 VladimirBrejcha. All rights reserved.
//

import UIKit

class ProgressTableViewCell: UITableViewCell {
    @IBOutlet weak var startProgressLabel: UILabel!
    @IBOutlet weak var endProgressLabel: UILabel!
    @IBOutlet weak var centerProgressLabel: UILabel!
    @IBOutlet weak var progressBarView: ProgressBar!
    var progress: CGFloat = 0.0 {
        willSet {
            progressBarView.showProgress(progress: newValue)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        progressBarView.showProgress(progress: progress)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}

