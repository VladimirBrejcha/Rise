import UIKit

public enum Background {
    case `default`
    case rich

    public var asUIView: UIView {
        let view = UIImageView()
        view.image = {
            switch self {
            case .default:
                return Asset.Background.default.image
            case .rich:
                return Asset.Background.rich.image
            }
        }()
        view.contentMode = .scaleAspectFill
        return view
    }
}
