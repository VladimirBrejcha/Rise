import UIKit

public protocol NibLoadable where Self: UIView {
    static var nibName: String { get }
}

public extension NibLoadable {
    static var nibName: String { String(describing: Self.self) }
    static var nib: UINib { UINib(nibName: Self.nibName, bundle: Bundle.module) }

    func setupFromNib() {
        guard let view = Self.nib.instantiate(withOwner: self, options: nil).first as? UIView
            else { fatalError("Error loading \(self) from nib") }
        addSubview(view)
        view.frame = bounds
    }
}
