import UIKit

@objc(ObjcFloatingButton)
public final class FloatingButton: Button {
    private var initialDraw: (() -> Void)?
    private let animation = VerticalPositionMoveAnimation()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        sharedInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        sharedInit()
    }
    
    public override func draw(_ rect: CGRect) {
        super.draw(rect)
        initialDraw?()
        initialDraw = nil
    }
    
    private func sharedInit() {
        initialDraw = { [weak self] in
            if let self = self {
                self.animation.add(to: self.layer)
            }
        }
    }
    
    deinit {
        animation.removeFromSuperlayer()
    }
}
