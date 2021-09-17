//
//  DaysCollectionCell.swift
//  Rise
//
//  Created by Vladimir Korolev on 17.02.2020.
//  Copyright © 2020 VladimirBrejcha. All rights reserved.
//

import UIKit
import LoadingView

typealias LeftRightTuple<T> = (left: T, right: T)
typealias LeftMiddleRightTuple<T> = (left: T, middle: T, right: T)

final class DaysCollectionCell: UICollectionViewCell, ConfigurableCell {
    @IBOutlet private weak var loadingView: LoadingView!
    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var leftImageView: UIImageView!
    @IBOutlet private var leftTopLabel: UILabel!
    @IBOutlet private weak var leftLabel: UILabel!
    @IBOutlet private weak var rightImageView: UIImageView!
    @IBOutlet private var rightTopLabel: UILabel!
    @IBOutlet private weak var rightLabel: UILabel!
    @IBOutlet var loadingViewTitle: UILabel!

    var repeatButtonHandler: RepeatHandler?
    
    typealias RepeatHandler = (DaysCollectionCell) -> Void

    struct Model: Hashable, Identifiable {
        enum State: Hashable {
            case loading
            case showingInfo (info: String)
            case showingError (error: String)
            case showingContent (left: String, right: String)
        }

        let state: State
        let image: LeftRightTuple<UIImage>
        let title: LeftMiddleRightTuple<String>

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

        layer.applyStyle(.usualBorder)

        leftTopLabel.applyStyle(.mediumSizedTitle)
        rightTopLabel.applyStyle(.mediumSizedTitle)
        loadingViewTitle.applyStyle(.mediumSizedTitle)
        leftLabel.applyStyle(.mediumSizedBody)
        rightLabel.applyStyle(.mediumSizedBody)
        loadingView.infoLabelFont = Style.Text.mediumSizedBody.font
        loadingView.backgroundColor = .clear
        
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

        leftImageView.image = model.image.left
        rightImageView.image =  model.image.right

        leftTopLabel.text = model.title.left
        rightTopLabel.text = model.title.right
        loadingViewTitle.text = model.title.middle
    }

    private func applyModel() {
        guard let model = model else { return }
        switch model.state {
        case .loading:
            self.loadingView.state = .loading
            self.containerView.isHidden = true
            self.loadingViewTitle.isHidden = false
        case .showingInfo(let info):
            self.loadingView.state = .info(message: info)
            self.containerView.isHidden = true
            self.loadingViewTitle.isHidden = false
        case .showingError(let error):
            self.loadingView.state = .error(message: error)
            self.containerView.isHidden = true
            self.loadingViewTitle.isHidden = false
        case .showingContent(let left, let right):
            self.leftLabel.text = left
            self.rightLabel.text = right
            self.loadingView.state = .hidden
            self.containerView.isHidden = false
            self.loadingViewTitle.isHidden = true
        }
    }
}

extension DaysCollectionCell.Model: Changeable {
    init(copy: ChangeableWrapper<DaysCollectionCell.Model>) {
        self.init(state: copy.state, image: copy.image, title: copy.title, id: copy.id)
    }
}
