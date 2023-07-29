import Foundation

public let calendar = Calendar.autoupdatingCurrent

extension Date {
  public var noon: Date {
    calendar.date(bySettingHour: 12, minute: 00, second: 00, of: self)!
  }

  public func changeDayStoringTime(to day: Day) -> Date {
    changeDayStoringTime(to: day.date)
  }

  public func changeDayStoringTime(to date: Date) -> Date {
    let dateComponents = calendar.dateComponents([.year, .month, .day], from: date)
      let timeComponents = calendar.dateComponents([.hour, .minute, .second, .nanosecond], from: self)
    guard
      let newDate = calendar.date(
        from: DateComponents(
          year: dateComponents.year,
          month: dateComponents.month,
          day: dateComponents.day,
          hour: timeComponents.hour,
          minute: timeComponents.minute,
          second: timeComponents.second,
          nanosecond: timeComponents.nanosecond
        )
      ) else {
      fatalError()
    }
    return newDate
  }

  public func addingTimeInterval(minutes timeInterval: Int) -> Date {
    addingTimeInterval(timeInterval.toSeconds())
  }

  public func addingTimeInterval(days: Int) -> Date {
    addingTimeInterval(TimeInterval(days * 24 * 60 * 60))
  }

  public var HHmmString: String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "HH:mm"
    return dateFormatter.string(from: self)
  }
}

