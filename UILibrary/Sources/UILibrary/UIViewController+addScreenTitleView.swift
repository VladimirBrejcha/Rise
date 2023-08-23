import UIKit

public extension UIView {
    
    func addScreenTitleView(_ titleView: UIView) {
        addSubview(titleView)
        titleView.activateConstraints {
            [$0.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
             $0.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
             $0.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor)]
        }
    }
}
