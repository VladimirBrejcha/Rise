public protocol Changeable {
  init(copy: ChangeableWrapper<Self>)
}

public extension Changeable {
  func changing(_ change: (inout ChangeableWrapper<Self>) -> Void) -> Self {
    var copy = ChangeableWrapper<Self>(self)
    change(&copy)
    return Self(copy: copy)
  }
}
