//
//  ImageLabelViewWithContextMenu.swift
//  Rise
//
//  Created by Vladimir Korolev on 21.02.2021.
//  Copyright © 2021 VladimirBrejcha. All rights reserved.
//

import UIKit
import Core

final class ImageLabelViewWithContextMenu:
    UIView,
    UIContextMenuInteractionDelegate
{
    private let contentView = ImageLabelView(frame: .zero)

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
        contentView.setState(
            .init(
                image: state.image,
                text: state.text
            )
        )
    }

    // MARK: - LifeCycle

    init() {
        super.init(frame: .zero)
        configure()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("This class does not support NSCoder")
    }

    private func configure() {
        backgroundColor = .clear
        addSubview(contentView)
        addInteraction(UIContextMenuInteraction(delegate: self))

        contentView.activateConstraints(
            contentView.topAnchor.constraint(equalTo: topAnchor),
            contentView.bottomAnchor.constraint(equalTo: bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: trailingAnchor)
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
        UIContextMenuConfiguration(
            identifier: String(describing: self.state?.contextViewController) as NSCopying,
            previewProvider: { [weak self] in
                self?.state?.contextViewController
            },
            actionProvider: { [weak self] _ in
                UIMenu(children: self?.state?.actions ?? [])
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
