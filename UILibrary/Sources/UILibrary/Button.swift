import UIKit

@objc(ObjcButton)
@IBDesignable
public class Button: UIButton, PropertyAnimatable, StyledButton {
    public var propertyAnimationDuration: Double = 0.1

    public var style: Style.Button = .primary
    
    var onTouchDown: (() -> Void)?
    public var onTouchUp: (() -> Void)?
    var onAnyTouchDown: (() -> Void)?
    var onAnyTouchUp: (() -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configure()
    }
    
    private func configure() {
        applyStyle(style)
        addTarget(self, action: #selector(handleAnyTouchDown(_:)), for: [.touchDown, .touchDragInside])
        addTarget(self, action: #selector(handleAnyTouchUp(_:)), for: [.touchUpInside, .touchDragOutside, .touchCancel])
        addTarget(self, action: #selector(handleTouchDown(_:)), for: [.touchDown])
        addTarget(self, action: #selector(handleTouchUp(_:)), for: [.touchUpInside])
    }
    
    @objc private func handleAnyTouchDown(_ sender: UIButton) {
        onAnyTouchDown?()
        animate {
            sender.transform = CGAffineTransform(scaleX: 0.98, y: 0.95)
        }
    }
    
    @objc private func handleAnyTouchUp(_ sender: UIButton) {
        onAnyTouchUp?()
        animate {
            sender.transform = CGAffineTransform.identity
        }
    }

    @objc private func handleTouchDown(_ sender: UIButton) {
        onTouchDown?()
    }

    @objc private func handleTouchUp(_ sender: UIButton) {
        onTouchUp?()
    }
}
