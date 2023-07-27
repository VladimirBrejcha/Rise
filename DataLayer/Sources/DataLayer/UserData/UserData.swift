import Foundation

public protocol UserData: AnyObject {
    var onboardingCompleted: Bool { get set }
    var scheduleOnPause: Bool { get set }
    var latestAppUsageDate: Date? { get set }
    var preferredWakeUpTime: Date? { get set }
    var keepAppOpenedSuggested: Bool { get set }
    
    var activeSleepStartDate: Date? { get set }
    var activeSleepEndDate: Date? { get set }
    var notificationsSuggested: Bool { get set }
    func invalidateActiveSleep()
}
