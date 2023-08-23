public protocol Styleable {
    associatedtype StyleType
    func applyStyle(_ style: StyleType)
}
