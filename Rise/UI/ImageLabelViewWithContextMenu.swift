//
//  ImageLabelViewWithContextMenu.swift
//  Rise
//
//  Created by Владимир Королев on 21.02.2021.
//  Copyright © 2021 VladimirBrejcha. All rights reserved.
//

import UIKit

final class ImageLabelViewWithContextMenu: UIView, Statefull, UIContextMenuInteractionDelegate {
    private let contentView: ImageLabelView = ImageLabelView(frame: CGRect.zero)

    // MARK: - Statefull
    struct State {
        let image: UIImage?
        let text: String?
        let contextViewController: UIViewController?
        let actions: [UIAction]
    }
    private(set) var state: State?
    func setState(_ state: State) {
        self.state = state
        contentView.setState(.init(image: state.image, text: state.text))
    }

    // MARK: - Internal -
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configure()
    }

    private func configure() {
        backgroundColor = .clear

        addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        addConstraints([
            topAnchor.constraint(equalTo: contentView.topAnchor),
            bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])

        addInteraction(UIContextMenuInteraction(delegate: self))
    }

    // MARK: - UIContextMenuInteractionDelegate -
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
        UIContextMenuConfiguration(
            identifier: String(describing: self.state?.contextViewController) as NSCopying,
            previewProvider: { [weak self] in self?.state?.contextViewController },
            actionProvider: { [weak self] _ in
                UIMenu(title: "", image: nil, identifier: nil, options: [], children: self?.state?.actions ?? [])
            }
        )
    }
}

extension ImageLabelViewWithContextMenu.State: Changeable {
    init(copy: ChangeableWrapper<ImageLabelViewWithContextMenu.State>) {
        self.init(
            image: copy.image,
            text: copy.text,
            contextViewController: copy.contextViewController,
            actions: copy.actions
        )
    }
}
