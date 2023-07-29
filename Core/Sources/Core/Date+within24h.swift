import Foundation

public extension Date {

    func withinNext24h(of now: Date) -> Date {
        var res = self
        if res < now {
            res = res.changeDayStoringTime(to: .today)
            if res < now {
                res = res.changeDayStoringTime(to: .tomorrow)
            }
        }
        else if (res.timeIntervalSince(now) / 60 / 60) > 24 {
            res = res.changeDayStoringTime(to: .today)
        }
        return res
    }
}
