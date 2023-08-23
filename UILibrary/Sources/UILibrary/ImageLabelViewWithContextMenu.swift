import UIKit
import Core

public final class ImageLabelViewWithContextMenu:
    UIView,
    UIContextMenuInteractionDelegate
{
    private let contentView = ImageLabelView(frame: .zero)

    public struct State {
        public init(image: UIImage? = nil, text: String? = nil, contextViewController: UIViewController? = nil, actions: [UIAction]) {
            self.image = image
            self.text = text
            self.contextViewController = contextViewController
            self.actions = actions
        }

        let image: UIImage?
        let text: String?
        let contextViewController: UIViewController?
        let actions: [UIAction]
    }

    private(set) var state: State?

    public func setState(_ state: State) {
        self.state = state
        contentView.setState(
            .init(
                image: state.image,
                text: state.text
            )
        )
    }

    // MARK: - LifeCycle

    public init() {
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

        contentView.activateConstraints {
            [$0.topAnchor.constraint(equalTo: topAnchor),
            $0.bottomAnchor.constraint(equalTo: bottomAnchor),
            $0.leadingAnchor.constraint(equalTo: leadingAnchor),
            $0.trailingAnchor.constraint(equalTo: trailingAnchor)]
        }
    }

    // MARK: - UIContextMenuInteractionDelegate

    public func contextMenuInteraction(
        _ interaction: UIContextMenuInteraction,
        previewForHighlightingMenuWithConfiguration configuration: UIContextMenuConfiguration
    ) -> UITargetedPreview? {
        let previewParams = UIPreviewParameters()
        previewParams.backgroundColor = .clear
        return UITargetedPreview(view: contentView, parameters: previewParams)
    }

    public func contextMenuInteraction(
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
    public init(copy: ChangeableWrapper<ImageLabelViewWithContextMenu.State>) {
        self.init(
            image: copy.image,
            text: copy.text,
            contextViewController: copy.contextViewController,
            actions: copy.actions
        )
    }
}
