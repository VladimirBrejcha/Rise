import UIKit

public final class ProgressBar: UIView, PropertyAnimatable {
    private var progress: Double = 0
    private let progressView = UIView()
    
    // MARK: - PropertyAnimatable
    
    public var propertyAnimationDuration: Double { progress * 3 }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        sharedInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        sharedInit()
    }
    
    private func sharedInit() {
        layer.cornerRadius = frame.height / 2
        clipsToBounds = true
        
        addSubview(progressView)
        progressView.layer.cornerRadius = (frame.height / 2)
        progressView.translatesAutoresizingMaskIntoConstraints = false
        progressView.leftAnchor.constraint(equalTo: leftAnchor, constant: -frame.width - 20).isActive = true
        progressView.heightAnchor.constraint(equalTo: heightAnchor).isActive = true
        progressView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        progressView.backgroundColor = Asset.Colors.violet.color
    }
    
    func showProgress(progress: CGFloat) {
        self.progress = Double(progress)
        
        animate {
            self.progressView.transform = CGAffineTransform(translationX: self.frame.width * progress, y: 0)
        }
    }
}
