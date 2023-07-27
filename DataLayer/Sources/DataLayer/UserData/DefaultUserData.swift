import Foundation
import Core

public final class DefaultUserData: UserData {
  @NonNilUserDefault("onboarding_completed", defaultValue: false)
  public var onboardingCompleted: Bool

  @NonNilUserDefault("schedule_on_pause", defaultValue: false)
  public var scheduleOnPause: Bool

  @UserDefault("latest_app_usage_date")
  public var latestAppUsageDate: Date?

  @UserDefault<Date>("preferred_wakeup_time")
  public var preferredWakeUpTime: Date?

  @NonNilUserDefault("keep_app_opened_suggested", defaultValue: false)
  public var keepAppOpenedSuggested: Bool

  @UserDefault("active_sleep_start_date")
  public var activeSleepStartDate: Date?

  @UserDefault("active_sleep_end_date")
  public var activeSleepEndDate: Date?

  public init() { }

  public func invalidateActiveSleep() {
    activeSleepStartDate = nil
    activeSleepEndDate = nil
  }
    @NonNilUserDefault("notifications_suggested", defaultValue: false)
    public var notificationsSuggested: Bool
}
