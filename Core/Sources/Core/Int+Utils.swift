public extension Int {
  func toSeconds() -> Double {
    Double(self * 60)
  }

  var HHmmString: String {
    let hours = self / 60
    let minutes = self % 60

    if minutes == 0 {
      return "\(hours) hours"
    } else if hours == 0 {
      return "\(minutes) minutes"
    } else {
      return "\(hours)h \(minutes)m"
    }
  }
}
