import Foundation
import DataLayer
import Core

public protocol HasManageActiveSleep {
    var manageActiveSleep: ManageActiveSleep { get }
}

/*
 * Provides start and end dates for active sleep (if exists)
 * Provides method to end sleep and therefore invalidates sleep dates
 */
public protocol ManageActiveSleep: AnyObject {
    var sleepStartedAt: Date? { get set }
    var alarmAt: Date? { get set }
    func endSleep()
}

final class ManageActiveSleepImpl: ManageActiveSleep {

    private let userData: UserData
    private let notificationManager: NotificationManager

    var sleepStartedAt: Date? {
        get { userData.activeSleepStartDate }
        set { userData.activeSleepStartDate = newValue }
    }
    var alarmAt: Date? {
        get { userData.activeSleepEndDate }
        set { userData.activeSleepEndDate = newValue }
    }

    init(_ userData: UserData,
         _ notificationManager: NotificationManager) {
        self.userData = userData
        self.notificationManager = notificationManager
    }

    func endSleep() {
        userData.invalidateActiveSleep()
        notificationManager.cleanDelivered()
    }
}
