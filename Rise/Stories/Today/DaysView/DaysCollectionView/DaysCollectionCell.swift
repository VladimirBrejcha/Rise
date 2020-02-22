//
//  NewDaysCollectionViewCell.swift
//  Rise
//
//  Created by Владимир Королев on 17.02.2020.
//  Copyright © 2020 VladimirBrejcha. All rights reserved.
//

import UIKit

enum DaysCollectionViewCellState {
    case loading
    case showingInfo (info: String)
    case showingError (error: String)
    case showingContent (left: String, right: String)
}

struct DaysCollectionCellModel {
    let state: DaysCollectionViewCellState
    let imageName: (left: String, right: String)
    let repeatButtonHandler: ((DaysCollectionCell) -> Void)?
}

final class DaysCollectionCell: UICollectionViewCell, ConfigurableCell {
    typealias Model = DaysCollectionCellModel

    @IBOutlet private weak var loadingView: LoadingView!
    @IBOutlet private weak var containerView: DesignableContainerView!
    @IBOutlet private weak var leftImageView: UIImageView!
    @IBOutlet private weak var leftLabel: UILabel!
    @IBOutlet private weak var rightImageView: UIImageView!
    @IBOutlet private weak var rightLabel: UILabel!
    
    private var repeatButtonHandler: ((DaysCollectionCell) -> Void)?
    
    // MARK: - LifeCycle -
    override func awakeFromNib() {
        super.awakeFromNib()
        
        loadingView.repeatButtonHandler = repeatButtonPressed
    }
    
    func repeatButtonPressed() {
        repeatButtonHandler?(self)
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        processModelUpdate?()
        processModelUpdate = nil
    }
    
    // MARK: - ConfigurableCell -
    func configure(with model: DaysCollectionCellModel) {
        leftImageView.image = UIImage(named: model.imageName.left)
        rightImageView.image = UIImage(named: model.imageName.right)
        repeatButtonHandler = model.repeatButtonHandler
        
        processModelUpdate = { [weak self] in
            guard let self = self else { return }
            
            switch model.state {
            case .loading:
                self.containerView.alpha = 0
                self.loadingView.show(state: .showingLoading)
                self.loadingView.alpha = 1
            case .showingInfo(let info):
                self.containerView.alpha = 0
                self.loadingView.show(state: .showingInfo(info: info))
                self.loadingView.alpha = 1
            case .showingError(let error):
                self.containerView.alpha = 0
                self.loadingView.show(state: .showingError(error: error))
                self.loadingView.alpha = 1
            case .showingContent(let left, let right):
                self.loadingView.alpha = 0
                self.containerView.alpha = 1
                self.leftLabel.text = left
                self.rightLabel.text = right
            }
        }
    }
    
    private var processModelUpdate: (() -> Void)?
}
