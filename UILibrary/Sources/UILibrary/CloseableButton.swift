public func closeableButton(
    touchHandler: @escaping () -> Void,
    closeHandler: @escaping () -> Void,
    style: Style.Button? = nil
) -> Button {
    let button = Button()
    if let style = style { button.applyStyle(style) }
    button.onTouchUp = { touchHandler() }
    let closeButton = closeButton(handler: closeHandler)
    button.addSubview(closeButton)
    closeButton.activateConstraints {
        [$0.trailingAnchor.constraint(equalTo: button.trailingAnchor, constant: -4),
        $0.centerYAnchor.constraint(equalTo: button.centerYAnchor),
        $0.widthAnchor.constraint(equalToConstant: 36),
        $0.heightAnchor.constraint(equalToConstant: 36)]
    }
    return button
}
