import CoreGraphics

public struct Gradient {
    let position: (start: CGPoint, end: CGPoint)
    let colors: [CGColor]
}

public protocol Gradientable {
    func apply(_ gradient: Gradient)
}
