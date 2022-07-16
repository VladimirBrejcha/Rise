@dynamicMemberLookup
public struct ChangeableWrapper<Wrapped> {
  private let wrapped: Wrapped
  private var changes: [PartialKeyPath<Wrapped>: Any] = [:]

  public init(_ wrapped: Wrapped) {
    self.wrapped = wrapped
  }

  public subscript<T>(dynamicMember keyPath: KeyPath<Wrapped, T>) -> T {
    get {
      changes[keyPath].flatMap { $0 as? T } ?? wrapped[keyPath: keyPath]
    }

    set {
      changes[keyPath] = newValue
    }
  }

  public subscript<T: Changeable>(
    dynamicMember keyPath: KeyPath<Wrapped, T>
  ) -> ChangeableWrapper<T> {
    get {
      ChangeableWrapper<T>(self[dynamicMember: keyPath])
    }

    set {
      self[dynamicMember: keyPath] = T(copy: newValue)
    }
  }
}
