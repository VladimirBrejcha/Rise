public extension Double {
  func toMinutes() -> Int {
    Int(self / 60)
  }

  var HHmmString: String {
    toMinutes().HHmmString
  }
}
