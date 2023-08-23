import QuartzCore.CALayer

public struct AnimationKeys {
    static let scale = "transform.scale"
    static let opacity = "opacity"
    static let positionY = "position.y"
}

public protocol Animation {
    func add(to layer: CALayer)
    func removeFromSuperlayer()
}
