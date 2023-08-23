import UIKit

public protocol StyledButton: UIButton, Styleable {
    var style: Style.Button { get set }
}

public extension StyledButton {
    func applyStyle(_ style: Style.Button) {
        self.style = style
        self.backgroundColor = style.backgroundColor
        if let effects = style.effects {
            self.layer.applyStyle(effects)
        }
        self.setTitleColor(style.selectedTitleColor, for: .selected)
        self.setTitleColor(style.titleStyle.color, for: .normal)
        self.setTitleColor(style.disabledTitleColor, for: .disabled)
        self.titleLabel?.font = style.titleStyle.font
    }
}
