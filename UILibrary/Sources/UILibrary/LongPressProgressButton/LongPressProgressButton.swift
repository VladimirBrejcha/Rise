import UIKit

@objc(LongPressProgressButton)
public final class LongPressProgressButton: UIView, NibLoadable {
    private lazy var button: Button = {
        let button = Button()
        addSubviews(button)
        button.activateConstraints(edgesTo(self, padding: UIEdgeInsets(top: 0, left: 0, bottom: 6, right: 0)))
        return button
    }()
    @IBOutlet private weak var progressView: UIProgressView!
    
    private var workItem: DispatchWorkItem?
    private var animator: UIViewPropertyAnimator?
    
    public var progressCompleted: ((LongPressProgressButton) -> Void)?
    
    public var title: String? {
        get { button.title(for: .normal) }
        set { button.setTitle(newValue, for: .normal) }
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
        setupFromNib()
        progressView.layer.cornerRadius = 3
        progressView.clipsToBounds = true
        button.onAnyTouchDown = { [weak self] in
            guard let self = self else { return }
            if self.workItem != nil { return }
            self.workItem = DispatchWorkItem { [weak self] in
                guard let self = self else { return }
                self.progressCompleted?(self)
                self.workItem = nil
            }
            if let workItem = self.workItem {
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.5, execute: workItem)
                self.progressView.progress = 1
                self.animator = UIViewPropertyAnimator(duration: 1.5, curve: .linear) {
                    self.progressView.layoutIfNeeded()
                }
                self.animator?.startAnimation()
            }
        }
        button.onAnyTouchUp = { [weak self] in
            guard let self = self else { return }
            if let workItem = self.workItem {
                workItem.cancel()
                self.workItem = nil
                if let animator = self.animator {
                    animator.stopAnimation(true)
                    self.progressView.setProgress(0, animated: false)
                }
            }
        }
    }
}
