public protocol PlayMelody {
    func play()
    func stop()
    var isActive: Bool { get }
}
