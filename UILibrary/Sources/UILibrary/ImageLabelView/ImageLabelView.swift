import UIKit

@objc(ImageLabelView)
public final class ImageLabelView: UIView, NibLoadable {

    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var label: UILabel!

    struct State {
        let image: UIImage?
        let text: String?
    }

    private(set) var state: State?

    func setState(_ state: State) {
        self.state = state
        imageView.image = state.image
        imageView.contentMode = .scaleAspectFit
        label.text = state.text
    }

    // MARK: - LifeCycle

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configure()
    }

    private func configure() {
        setupFromNib()
        backgroundColor = .clear
        imageView.tintColor = .white
        label.textColor = .white
        label.textAlignment = .center
        label.numberOfLines = 0
        layer.cornerRadius = 16
        layer.applyStyle(.usualBorder)
    }
}
