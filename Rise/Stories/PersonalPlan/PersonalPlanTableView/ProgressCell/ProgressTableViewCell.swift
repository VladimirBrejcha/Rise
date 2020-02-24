//
//  ProgressTableViewCell.swift
//  Rise
//
//  Created by Владимир Королев on 11/09/2019.
//  Copyright © 2019 VladimirBrejcha. All rights reserved.
//

import UIKit

final class ProgressTableViewCell: UITableViewCell, ConfigurableCell {
    typealias Model = ProgressTableCellModel
    
    @IBOutlet private weak var startProgressLabel: UILabel!
    @IBOutlet private weak var endProgressLabel: UILabel!
    @IBOutlet private weak var centerProgressLabel: UILabel!
    @IBOutlet private weak var progressBarView: ProgressBar!
    @IBOutlet private weak var cellContentView: UIView!
    @IBOutlet private weak var loadingView: LoadingView!
    
    private var processModelUpdate: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        loadingView.containerView.background = .clear
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        processModelUpdate?()
        processModelUpdate = nil
    }
    
    // MARK: - ConfigurableCell -
    func configure(with model: ProgressTableCellModel) {
        processModelUpdate = {
            self.startProgressLabel.text = model.text.left
            self.centerProgressLabel.text = model.text.center
            self.endProgressLabel.text = model.text.right
            if let progress = model.progress {
                self.loadingView.changeState(to: .content)
                self.progressBarView.showProgress(progress: CGFloat(progress))
            } else {
                self.loadingView.changeState(to: .info(message: "Your plan is paused"))
            }
        }
    }
}
