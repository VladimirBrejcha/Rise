import Foundation

public enum Day {
  case yesterday
  case today
  case tomorrow
  
  var date: Date {
    Date().addingTimeInterval(minutes: minutesFromToday)
  }
  
  private var minutesFromToday: Int {
    switch self {
    case .yesterday: return -(24 * 60)
    case .today: return 0
    case .tomorrow: return 24 * 60
    }
  }
}
