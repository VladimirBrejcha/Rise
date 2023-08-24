import UIKit

public enum Style {

    // MARK: - Layer

    public struct Layer {

        public init(shadow: Style.Layer.Shadow = Shadow(),
                      border: Style.Layer.Border = Border(),
                      cornerRadius: CGFloat = 0
        ) {
            self.shadow = shadow
            self.border = border
            self.cornerRadius = cornerRadius
        }

        private(set) var shadow: Shadow
        private(set) var border: Border
        private(set) var cornerRadius: CGFloat

        // MARK: Instances

        public static var usualBorder: Layer {
            Layer(border: .usual, cornerRadius: 16)
        }

        public static var gloomingIcon: Layer {
            Layer(shadow: Shadow(
                radius: 15, opacity: 0.6,
                color: Asset.Colors.lightBlue.color.cgColor)
            )
        }

        // MARK: Shadow

        public struct Shadow {

            public init(radius: CGFloat = 0,
                        opacity: Float = 0,
                        offset: CGSize = CGSize(width: 0, height: 0),
                        color: CGColor = UIColor.clear.cgColor
            ) {
                self.radius = radius
                self.opacity = opacity
                self.offset = offset
                self.color = color
            }

            private(set) var radius: CGFloat
            private(set) var opacity: Float
            private(set) var offset: CGSize
            private(set) var color: CGColor

            // MARK: Instances

            public static var usual: Shadow {
                .init(
                    radius: 12,
                    opacity: 0.41,
                    offset: CGSize(width: 0, height: 4),
                    color: Asset.Colors.lightBlue.color.cgColor
                )
            }

            public static var onboardingShadow: Shadow {
                .init(
                    radius: 12,
                    opacity: 0.55,
                    offset: .init(width: 0, height: 0),
                    color: Asset.Colors.darkBlue.color.cgColor
                )
            }
        }

        // MARK: Border

        public struct Border {
            public init(
                color: CGColor = UIColor.clear.cgColor,
                width: CGFloat = 0
            ) {
                self.color = color
                self.width = width
            }

            private(set) var color: CGColor
            private(set) var width: CGFloat

            // MARK: Instances

            static var usual: Border {
                Border(
                    color: Asset.Colors.whiteSeparator.color.cgColor,
                    width: 1
                )
            }
        }
    }

    // MARK: - TabBar

    public enum TabBar {

        // MARK: Item

        public struct Item {

            let iconColor: (normal: UIColor, selected: UIColor)

            // MARK: Instances

            public static var usual: Item {
                Item(
                    iconColor: (
                        normal: Asset.Colors.whiteSeparator.color,
                        selected: Asset.Colors.white.color
                    )
                )
            }
        }
    }

    // MARK: - Text

    public struct Text {

        public init(font: UIFont,
                    color: UIColor? = nil,
                    alignment: NSTextAlignment? = nil
        ) {
            self.font = font
            self.color = color
            self.alignment = alignment
        }

        public let font: UIFont
        private(set) var color: UIColor?
        private(set) var alignment: NSTextAlignment?

        // MARK: Instances

        public static var footer: Text {
            Text(font: .boldSystemFont(ofSize: 13), color: Asset.Colors.white.color, alignment: .center)
        }

        public static var boldBigTitle: Text {
            Text(font: .boldSystemFont(ofSize: 30), color: Asset.Colors.white.color, alignment: .center)
        }

        public static var mediumSizedTitle: Text {
            Text(font: .systemFont(ofSize: 18, weight: .medium), color: Asset.Colors.white.color, alignment: .center)
        }

        public static var mediumSizedBody: Text {
            Text(font: .systemFont(ofSize: 18), color: Asset.Colors.white.color)
        }

        public static var description: Text {
            Text(font: .systemFont(ofSize: 14), color: Asset.Colors.white.color.withAlphaComponent(0.7))
        }

        public static var onTopOfRich: Text {
            Text(
                font: .systemFont(ofSize: 20, weight: .medium),
                color: Asset.Colors.darkBlue.color
            )
        }

        public static var floating: Text {
            Text(font: .systemFont(ofSize: 15),
                 color: Asset.Colors.white.color)
        }

        public static var largeTime: Text {
            Text(font: .systemFont(ofSize: 54, weight: .semibold),
                 color: Asset.Colors.white.color)
        }
    }

    // MARK: - Button

    public struct Button {

        public init(
            disabledTitleColor: UIColor? = nil,
            selectedTitleColor: UIColor? = nil,
            titleStyle: Style.Text,
            backgroundColor: UIColor = .clear,
            effects: Style.Layer? = nil
        ) {
            self.disabledTitleColor = disabledTitleColor
            self.selectedTitleColor = selectedTitleColor
            self.titleStyle = titleStyle
            self.backgroundColor = backgroundColor
            self.effects = effects
        }

        private(set) var disabledTitleColor: UIColor?
        private(set) var selectedTitleColor: UIColor?
        let titleStyle: Text
        private(set) var backgroundColor: UIColor
        private(set) var effects: Layer?

        // MARK: Instances

        public static var primary: Button {
            Button(
                disabledTitleColor: Asset.Colors.black.color.withAlphaComponent(0.5),
                titleStyle: Text(
                    font: UIFont.boldSystemFont(ofSize: 18),
                    color: Asset.Colors.black.color
                ),
                backgroundColor: Asset.Colors.white.color,
                effects: Layer(
                    shadow: .usual,
                    cornerRadius: 22
                )
            )
        }

        public static var image: Button {
            Button(
                disabledTitleColor: nil,
                selectedTitleColor: nil,
                titleStyle: .footer,
                backgroundColor: .clear,
                effects: nil
            )
        }

        public static var secondary: Button {
            Button(
                disabledTitleColor: Asset.Colors.white.color.withAlphaComponent(0.5),
                titleStyle: Text(
                    font: UIFont.systemFont(ofSize: 18),
                    color: Asset.Colors.white.color
                ),
                backgroundColor: .clear,
                effects: Layer(
                    border: .usual,
                    cornerRadius: 22
                )
            )
        }
    }
    
    // MARK: - Picker

    public struct Picker {

        let textColor: UIColor
        let lineColor: UIColor

        // MARK: Instances

        public static var usual: Picker {
            Picker(textColor: Asset.Colors.white.color, lineColor: .clear)
        }
    }

    // MARK: - Segmented control

    public struct SegmentedControl {
        let selectionColor: UIColor
        let backgroundColor: UIColor
        let selectedTextColor: UIColor
        let normalTextColor: UIColor

        public static var usual: SegmentedControl {
            .init(
                selectionColor: Asset.Colors.white.color.withAlphaComponent(0.3),
                backgroundColor: .clear,
                selectedTextColor: Asset.Colors.white.color,
                normalTextColor: Asset.Colors.white.color.withAlphaComponent(0.3)
            )
        }
    }
}

public extension NSAttributedString {
    static func onTopOfRich(text: String) -> NSAttributedString {
        NSAttributedString(
            string: text,
            attributes: [
                .strokeColor: Asset.Colors.lightBlue.color.withAlphaComponent(0.5),
                .foregroundColor: UIColor.white,
                .strokeWidth: -1.0
            ]
        )
    }

    static func descriptionOnTopOfRich(text: String, alignment: NSTextAlignment = .center) -> NSAttributedString {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = alignment
        paragraphStyle.paragraphSpacing = 8
        return NSAttributedString(string: text, attributes: [
            .strokeColor: Asset.Colors.lightBlue.color.withAlphaComponent(0.7),
            .foregroundColor: UIColor.white,
            .strokeWidth: -1.0,
            .paragraphStyle: paragraphStyle
        ])
    }
}
