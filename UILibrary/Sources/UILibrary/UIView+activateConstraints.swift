import UIKit

public extension UIView {
    func activateConstraints(_ constraints: (UIView) -> [NSLayoutConstraint]) {
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(constraints(self))
    }

    func edgesTo(_ view: UIView) -> (UIView) -> [NSLayoutConstraint] {
        { [$0.leadingAnchor.constraint(equalTo: view.leadingAnchor),
           $0.trailingAnchor.constraint(equalTo: view.trailingAnchor),
           $0.topAnchor.constraint(equalTo: view.topAnchor),
           $0.bottomAnchor.constraint(equalTo: view.bottomAnchor)]
        }
    }

    func edgesTo(_ view: UIView, padding: UIEdgeInsets) -> (UIView) -> [NSLayoutConstraint] {
        { [$0.leftAnchor.constraint(equalTo: view.leftAnchor, constant: padding.left),
           $0.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -padding.right),
           $0.topAnchor.constraint(equalTo: view.topAnchor, constant: padding.top),
           $0.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -padding.bottom)]
        }
    }
}
