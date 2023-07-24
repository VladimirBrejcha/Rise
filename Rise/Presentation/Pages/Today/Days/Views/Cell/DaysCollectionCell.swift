//
//  DaysCollectionCell.swift
//  Rise
//
//  Created by Vladimir Korolev on 17.02.2020.
//  Copyright © 2020 VladimirBrejcha. All rights reserved.
//

import UIKit
import LoadingView

extension Days {

    final class CollectionCell:
        UICollectionViewCell,
        ConfigurableCell,
        UIContextMenuInteractionDelegate
    {
        typealias RepeatHandler = (Model.ID) -> Void
        var repeatButtonHandler: RepeatHandler?

        private var model: Model?

        var contextViewController: UIViewController?

        // MARK: - Subviews

        private lazy var loadingView: LoadingView = {
            let view = LoadingView()
            view.infoLabelFont = Style.Text.mediumSizedBody.font
            view.backgroundColor = .clear
            view.repeatTouchUpHandler = { [weak self] _ in
                if let self = self, let id = self.model?.id {
                    self.repeatButtonHandler?(id)
                }
            }
            return view
        }()

        private lazy var loadingViewTitle: UILabel = {
            let label = UILabel()
            label.applyStyle(.mediumSizedTitle)
            return label
        }()

        private lazy var HStack: UIStackView = {
            let stack = UIStackView()
            stack.axis = .horizontal
            stack.distribution = .fillEqually
            stack.spacing = 20
            return stack
        }()

        private lazy var leftVStack: SideItemVStack = {
            let stack = SideItemVStack()
            return stack
        }()

        private lazy var rightVStack: SideItemVStack = {
            let stack = SideItemVStack()
            return stack
        }()

        // MARK: - LifeCycle

        override init(frame: CGRect) {
            super.init(frame: frame)
            setup()
        }

        @available(*, unavailable)
        required init?(coder: NSCoder) {
            fatalError("This class does not support NSCoder")
        }

        private func setup() {
            setupViews()
            setupLayout()
            addInteraction(UIContextMenuInteraction(delegate: self))
        }

        private func setupViews() {
            layer.applyStyle(.usualBorder)
            contentView.addSubviews(
                HStack.addArrangedSubviews(
                    leftVStack,
                    rightVStack
                ),
                loadingView,
                loadingViewTitle
            )
        }

        func configure(with model: Model) {
            self.model = model

            var leftBottomText = ""
            var rightBottomText = ""

            switch model.state {
            case .loading:
                loadingView.state = .loading
                HStack.isHidden = true
                loadingViewTitle.isHidden = false
            case .showingInfo(let info):
                loadingView.state = .info(message: info)
                HStack.isHidden = true
                loadingViewTitle.isHidden = false
            case .showingError(let error):
                loadingView.state = .error(message: error)
                HStack.isHidden = true
                loadingViewTitle.isHidden = false
            case .showingContent(let left, let right):
                leftBottomText = left
                rightBottomText = right
                loadingView.state = .hidden
                HStack.isHidden = false
                loadingViewTitle.isHidden = true
            }

            leftVStack.configure(
                topText: model.title.left,
                bottomText: leftBottomText,
                image: model.image.left
            )
            rightVStack.configure(
                topText: model.title.right,
                bottomText: rightBottomText,
                image: model.image.right
            )
            loadingViewTitle.text = model.title.middle
        }

        // MARK: - Layout

        override func prepareForReuse() {
            super.prepareForReuse()
            loadingView.restoreAnimation()
        }

        override func didMoveToWindow() {
            super.didMoveToWindow()
            loadingView.restoreAnimation()
        }

        private func setupLayout() {
            loadingViewTitle.activateConstraints(
                loadingViewTitle.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
                loadingViewTitle.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
                loadingViewTitle.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
            )
            loadingView.activateConstraints(
                loadingView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
                loadingView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
                loadingView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
                loadingView.topAnchor.constraint(equalTo: loadingViewTitle.bottomAnchor, constant: 4)
            )
            HStack.activateConstraints(
                HStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
                HStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
                HStack.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -4),
                HStack.bottomAnchor.constraint(greaterThanOrEqualTo: contentView.bottomAnchor, constant: -12),
                HStack.topAnchor.constraint(greaterThanOrEqualTo: contentView.topAnchor, constant: 4),
                HStack.topAnchor.constraint(lessThanOrEqualTo: contentView.topAnchor, constant: 12),
                HStack.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
            )
        }

        // MARK: - UIContextMenuInteractionDelegate

        func contextMenuInteraction(
            _ interaction: UIContextMenuInteraction,
            previewForHighlightingMenuWithConfiguration configuration: UIContextMenuConfiguration
        ) -> UITargetedPreview? {
            let previewParams = UIPreviewParameters()
            previewParams.backgroundColor = .clear
            return UITargetedPreview(view: contentView, parameters: previewParams)
        }

        func contextMenuInteraction(
            _ interaction: UIContextMenuInteraction,
            configurationForMenuAtLocation location: CGPoint
        ) -> UIContextMenuConfiguration? {
            guard case .showingContent = model?.state else { return nil }
            return UIContextMenuConfiguration(
                identifier: String(describing: contextViewController) as NSCopying,
                previewProvider: { [weak self] in
                    self?.contextViewController
                },
                actionProvider: { _ in
                    UIMenu(children: [])
                }
            )
        }
    }
}
