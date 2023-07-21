public extension Int {
    func toSeconds() -> Double {
        Double(self * 60)
    }

    var HHmmString: String {
        let hours = self / 60
        let minutes = self % 60

        if minutes == 0 && hours == 0 {
            return "1 minute"
        }
        if minutes == 0 {
            if hours == 1 {
                return "\(hours) hour"
            }
            return "\(hours) hours"
        } else if hours == 0 {
            if minutes == 1 {
                return "\(minutes) minute"
            }
            return "\(minutes) minutes"
        } else {
            return "\(hours)h \(minutes)m"
        }
    }
}
