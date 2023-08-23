import UIKit

public enum Title {

    public enum CloseButton {
        case none
        case `default`(handler: () -> Void)
    }

    public static func make(
        title: String,
        closeButton button: CloseButton
    ) -> UIView {
        let view = UIView()
        view.backgroundColor = .clear

        let titleLabel: UILabel = {
            let label = UILabel()
            label.applyStyle(.mediumSizedTitle)
            label.text = title
            return label
        }()

        view.activateConstraints {
            [$0.heightAnchor.constraint(equalToConstant: 45)]
        }

        view.addSubview(titleLabel)
        titleLabel.activateConstraints {
            [$0.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            $0.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            $0.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 5)]
        }

        if case let .default(handler) = button {
            let closeButton: Button = closeButton(handler: handler)
            view.addSubview(closeButton)
            closeButton.activateConstraints {
                [$0.widthAnchor.constraint(equalToConstant: 35),
                $0.heightAnchor.constraint(equalToConstant: 35),
                $0.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
                $0.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 5)]
            }
        }

        return view
    }
}
