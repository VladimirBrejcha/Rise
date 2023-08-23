import UIKit

@IBDesignable
public class DesignableContainerView: UIView {
    @IBInspectable var cornerRadius: CGFloat {
        get { layer.cornerRadius }
        set { layer.cornerRadius = newValue }
    }
    
    @IBInspectable var background: UIColor? {
        get { backgroundColor }
        set { backgroundColor = newValue }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        sharedInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        sharedInit()
    }
    
    private func sharedInit() {
        background = Asset.Colors.defaultContainerBackground.color
        cornerRadius = 12
        layer.borderWidth = 1
        layer.borderColor =
        Asset.Colors.white.color.withAlphaComponent(0.85).cgColor
        clipsToBounds = true
    }
}

