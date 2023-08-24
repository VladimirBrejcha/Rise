import UIKit
import SelectableStackView
import UILibrary

public final class SelectableStackViewButton: UIButton, StyledButton, ObservableBySelectableStackView {

    public var style: Style.Button = .init(
        selectedTitleColor: Asset.Colors.white.color,
        titleStyle: .init(
            font: UIFont.systemFont(ofSize: 13),
            color: Asset.Colors.white.color.withAlphaComponent(0.5),
            alignment: .center
        ),
        backgroundColor: .clear
    )
    public var observer: ((ObservableBySelectableStackView) -> Void)?
    public var handlingSelfSelection: Bool = false

    public convenience init(title: String) {
        self.init(frame: .zero)
        self.applyStyle(style)
        self.setTitle(title, for: .normal)
        addTarget(self, action: #selector(touchUpInside), for: .touchUpInside)
    }

    @objc private func touchUpInside() {
        observer?(self)
    }
}
