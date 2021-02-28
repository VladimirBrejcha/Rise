//
//  DaysCollectionCell.swift
//  Rise
//
//  Created by Владимир Королев on 17.02.2020.
//  Copyright © 2020 VladimirBrejcha. All rights reserved.
//

import UIKit
import LoadingView

final class DaysCollectionCell: UICollectionViewCell, ConfigurableCell {
    @IBOutlet private weak var loadingView: LoadingView!
    @IBOutlet private weak var containerView: DesignableContainerView!
    @IBOutlet private weak var leftImageView: UIImageView!
    @IBOutlet private var leftTopLabel: UILabel!
    @IBOutlet private weak var leftLabel: UILabel!
    @IBOutlet private weak var rightImageView: UIImageView!
    @IBOutlet private var rightTopLabel: UILabel!
    @IBOutlet private weak var rightLabel: UILabel!
    @IBOutlet var loadingViewTitle: UILabel!

    private var repeatButtonHandler: RepeatHandler?
    
    typealias RepeatHandler = (DaysCollectionCell) -> Void
    
    enum State: Hashable {
        case loading
        case showingInfo (info: String)
        case showingError (error: String)
        case showingContent (left: String, right: String)
    }

    struct Model: Hashable, Identifiable {
        let state: State
        let imageName: (left: String, right: String)
        let repeatHandler: RepeatHandler

        // MARK: - Identifiable
        let id: String

        // MARK: - Equatable
        static func == (lhs: DaysCollectionCell.Model, rhs: DaysCollectionCell.Model) -> Bool {
            lhs.id == rhs.id && lhs.state == rhs.state
        }

        // MARK: - Hashable
        func hash(into hasher: inout Hasher) {
            hasher.combine(id)
        }
    }
    
    // MARK: - LifeCycle -
    override func awakeFromNib() {
        super.awakeFromNib()
        loadingView.repeatTouchUpHandler = { [weak self] _ in
            if let self = self {
                self.repeatButtonHandler?(self)
            }
        }
    }

    override func layoutSubviews() {
        applyModel()
        super.layoutSubviews()
    }
    
    // MARK: - ConfigurableCell -
    private var model: Model?
    func configure(with model: Model) {
        self.model = model
        repeatButtonHandler = model.repeatHandler
        leftTopLabel.font = UIFont.boldSystemFont(ofSize: 18)
        leftTopLabel.text = "Sunrise"
        rightTopLabel.font = UIFont.boldSystemFont(ofSize: 18)
        rightTopLabel.text = "Sunset"
        leftLabel.font = UIFont.systemFont(ofSize: 18)
        rightLabel.font = UIFont.systemFont(ofSize: 18)
        rightLabel.textColor = .white
        leftLabel.textColor = .white
        loadingViewTitle.textColor = .white
        rightTopLabel.textColor = .white
        leftTopLabel.textColor = .white
        loadingView.backgroundColor = .clear
        loadingView.layer.borderColor = UIColor.white.withAlphaComponent(0.85).cgColor
        loadingView.layer.borderWidth = 1
        loadingView.infoLabelFont = UIFont.systemFont(ofSize: 18)
        leftImageView.image = UIImage(systemName: "sunrise.fill")?.applyingSymbolConfiguration(.init(pointSize: 44, weight: .light))
        rightImageView.image = UIImage(systemName: "sunset.fill")?.applyingSymbolConfiguration(.init(pointSize: 44, weight: .light))
        loadingViewTitle.font = UIFont.boldSystemFont(ofSize: 18)
        loadingViewTitle.text = "Scheduled sleep"
    }

    private func applyModel() {
        guard let model = model else { return }
//        leftImageView.image = UIImage(named: model.imageName.left)
//        rightImageView.image = UIImage(named: model.imageName.right)
        switch model.state {
        case .loading:
            self.loadingView.state = .loading
            self.containerView.isHidden = true
        case .showingInfo(let info):
            self.loadingView.state = .info(message: info)
            self.containerView.isHidden = true
        case .showingError(let error):
            self.loadingView.state = .error(message: error)
            self.containerView.isHidden = true
        case .showingContent(let left, let right):
            self.leftLabel.text = left
            self.rightLabel.text = right
            self.loadingView.state = .hidden
            self.containerView.isHidden = false
        }
    }
}

extension DaysCollectionCell.Model: Changeable {
    init(copy: ChangeableWrapper<DaysCollectionCell.Model>) {
        self.init(state: copy.state, imageName: copy.imageName, repeatHandler: copy.repeatHandler, id: copy.id)
    }
}
