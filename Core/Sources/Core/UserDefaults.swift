import Foundation

fileprivate let userDefaults = UserDefaults.standard
fileprivate let userDefaultsDomain = Bundle.main.bundleIdentifier ?? ""
fileprivate extension String {
  var appendingAppDomain: String {
    "\(userDefaultsDomain).\(self)"
  }
}

@propertyWrapper
public struct UserDefault<T> {
  let key: String

  public init(_ key: String) {
    self.key = key.appendingAppDomain
  }

  public var wrappedValue: T? {
    get { userDefaults.object(forKey: key) as? T }
    set { userDefaults.set(newValue, forKey: key) }
  }
}

@propertyWrapper
public struct NonNilUserDefault<T> {
  let key: String
  let defaultValue: T

  public init(_ key: String, defaultValue: T) {
    self.key = key.appendingAppDomain
    self.defaultValue = defaultValue
    userDefaults.register(defaults: [key: defaultValue])
  }

  public var wrappedValue: T {
    get { userDefaults.object(forKey: key) as? T ?? defaultValue }
    set { userDefaults.set(newValue, forKey: key) }
  }
}
