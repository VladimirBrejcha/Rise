import UIKit

@objc(SliderWithValues)
@IBDesignable
public final class SliderWithValues: UIView, NibLoadable {
    @IBOutlet public weak var slider: UISlider!
    @IBOutlet public weak var leftLabel: UILabel!
    @IBOutlet public weak var rightLabel: UILabel!
    @IBOutlet public weak var centerLabel: UILabel!
    
    public var centerLabelDataSource: ((Float) -> String)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupFromNib()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupFromNib()
    }
    
    @IBAction private func valueChanged(_ sender: UISlider) {
        centerLabel.text = centerLabelDataSource?(sender.value)
    }
}
