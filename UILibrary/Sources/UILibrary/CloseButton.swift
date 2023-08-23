func closeButton(handler: @escaping () -> Void) -> Button {
    let closeButton = Button()
    closeButton.applyStyle(.image)
    closeButton.setImage(Asset.cancel.image, for: .normal)
    closeButton.tintColor = Asset.Colors.white.color
    closeButton.onTouchUp = { handler() }
    return closeButton
}
