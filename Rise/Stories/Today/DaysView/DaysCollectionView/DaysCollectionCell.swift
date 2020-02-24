//
//  DaysCollectionCell.swift
//  Rise
//
//  Created by Владимир Королев on 17.02.2020.
//  Copyright © 2020 VladimirBrejcha. All rights reserved.
//

import UIKit

final class DaysCollectionCell: UICollectionViewCell, ConfigurableCell {
    typealias Model = DaysCollectionCellModel

    @IBOutlet private weak var loadingView: LoadingView!
    @IBOutlet private weak var containerView: DesignableContainerView!
    @IBOutlet private weak var leftImageView: UIImageView!
    @IBOutlet private weak var leftLabel: UILabel!
    @IBOutlet private weak var rightImageView: UIImageView!
    @IBOutlet private weak var rightLabel: UILabel!
    
    private var repeatButtonHandler: ((DaysCollectionCell) -> Void)?
    
    private var processModelUpdate: (() -> Void)?
    
    // MARK: - LifeCycle -
    override func awakeFromNib() {
        super.awakeFromNib()
        
        loadingView.repeatButtonHandler = {
            self.repeatButtonHandler?(self)
        }
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
                self.loadingView.changeState(to: .loading)
            case .showingInfo(let info):
                self.loadingView.changeState(to: .info(message: info))
            case .showingError(let error):
                self.loadingView.changeState(to: .error(message: error))
            case .showingContent(let left, let right):
                self.leftLabel.text = left
                self.rightLabel.text = right
                self.loadingView.changeState(to: .content)
            }
        }
    }
}
