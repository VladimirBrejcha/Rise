import UIKit.UIViewController

public extension UIViewController {
    
    enum PresentationStyle {
        case fullScreen
        case modal
    }
    
    func present(
        _ controller: UIViewController,
        with style: PresentationStyle,
        animated: Bool = true,
        completion: (() -> Void)? = nil
    ) {
        switch style {
        case .fullScreen:
            modalPresentationStyle = .fullScreen
            controller.modalPresentationStyle = .fullScreen
            present(controller, animated: animated, completion: completion)
        case .modal:
            modalPresentationStyle = .pageSheet
            controller.modalPresentationStyle = .pageSheet
            present(controller, animated: animated, completion: completion)
        }
    }
}
