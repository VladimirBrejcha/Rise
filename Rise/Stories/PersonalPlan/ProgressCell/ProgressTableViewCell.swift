//
//  ProgressTableViewCell.swift
//  Rise
//
//  Created by Владимир Королев on 11/09/2019.
//  Copyright © 2019 VladimirBrejcha. All rights reserved.
//

import UIKit

final class ProgressTableViewCell: UITableViewCell {
    @IBOutlet weak var startProgressLabel: UILabel!
    @IBOutlet weak var endProgressLabel: UILabel!
    @IBOutlet weak var centerProgressLabel: UILabel!
    @IBOutlet private weak var progressBarView: ProgressBar!
    @IBOutlet private weak var cellContentView: UIView!
    @IBOutlet private weak var loadingView: LoadingView!
    
    var progress: CGFloat = 0.0 {
        didSet {
            progressBarView.showProgress(progress: progress)
        }
    }
    
    var paused: Bool = true {
        didSet {
            // TODO: - animation doesnt work
            UIView.animate(withDuration: 0.15) {
                self.cellContentView.alpha = self.paused ? 0 : 1
                self.loadingView.alpha = self.paused ? 1 : 0
            }
            if paused {
                loadingView.showInfo(with: "Your plan is paused")
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        loadingView.containerView.background = .clear
        progressBarView.showProgress(progress: progress)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}

