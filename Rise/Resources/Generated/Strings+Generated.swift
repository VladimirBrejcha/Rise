// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
internal enum Text {
  /// Adjust schedule
  internal static let adjustSchedule = Text.tr("Localizable", "adjust_schedule")
  /// Sometimes we all miss our sleep schedule
  internal static let adjustScheduleDescription = Text.tr("Localizable", "adjust_schedule_description")
  /// If you missed sleep
  internal static let adjustScheduleShortDescription = Text.tr("Localizable", "adjust_schedule_short_description")
  /// In case this happens to you, you can update the Rise schedule to better suit your current situation. Remember, there is no need to rush, good sleep requires careful attention.
  internal static let adjustScheduleSuggestionToAdjust = Text.tr("Localizable", "adjust_schedule_suggestion_to_adjust")
  /// An internal error occurred
  internal static let anInternalErrorOccurred = Text.tr("Localizable", "an_internal_error_occurred")
  /// Edit Rise schedule
  internal static let editRiseSchedule = Text.tr("Localizable", "edit_rise_schedule")
  /// Failed to load time
  internal static let failedToLoadTime = Text.tr("Localizable", "failed_to_load_time")
  /// It's time to sleep!
  internal static let itsTimeToSleep = Text.tr("Localizable", "its_time_to_sleep!")
  /// last time I went to sleep at
  internal static let lastTimeIWentSleepAt = Text.tr("Localizable", "last_time_i_went_sleep_at")
  /// Location access is required to perform refresh
  internal static let locationAccessIsRequiredToPerformRefresh = Text.tr("Localizable", "location_access_is_required_to_perform_refresh")
  /// Location access missing
  internal static let locationAccessMissing = Text.tr("Localizable", "location_access_missing")
  /// No schedule for the day
  internal static let noScheduleForTheDay = Text.tr("Localizable", "no_schedule_for_the_day")
  /// Refresh
  internal static let refresh = Text.tr("Localizable", "refresh")
  /// Refresh sun times
  internal static let refreshSunTimes = Text.tr("Localizable", "refresh_sun_times")
  /// We store your location on the device to provide fast and energy efficient access to sunrise/sunset times even offline
  internal static let refreshSunTimesDescription = Text.tr("Localizable", "refresh_sun_times_description")
  /// Rise schedule is paused
  internal static let riseScheduleIsPaused = Text.tr("Localizable", "rise_schedule_is_paused")
  /// Save
  internal static let save = Text.tr("Localizable", "save")
  /// Scheduled sleep
  internal static let scheduledSleep = Text.tr("Localizable", "scheduled_sleep")
  /// Sleep
  internal static let sleep = Text.tr("Localizable", "sleep")
  /// Sleep in just a %@ mins
  internal static func sleepInJustAFew(_ p1: Any) -> String {
    return Text.tr("Localizable", "sleep_in_just_a_few", String(describing: p1))
  }
  /// Sleep is scheduled in %@
  internal static func sleepIsScheduledIn(_ p1: Any) -> String {
    return Text.tr("Localizable", "sleep_is_scheduled_in", String(describing: p1))
  }
  /// Sleeping
  internal static let sleeping = Text.tr("Localizable", "sleeping")
  /// Stop
  internal static let stop = Text.tr("Localizable", "stop")
  /// Success!
  internal static let success = Text.tr("Localizable", "success")
  /// Sun position
  internal static let sunPosition = Text.tr("Localizable", "sun_position")
  /// Sunrise
  internal static let sunrise = Text.tr("Localizable", "sunrise")
  /// Sunset
  internal static let sunset = Text.tr("Localizable", "sunset")
  /// Time not found
  internal static let timeNotFound = Text.tr("Localizable", "time_not_found")
  /// To bed
  internal static let toBed = Text.tr("Localizable", "to_bed")
  /// Today
  internal static let today = Text.tr("Localizable", "today")
  /// Tomorrow
  internal static let tomorrow = Text.tr("Localizable", "tomorrow")
  /// In case if your location changed use refresh to update it with actual data
  internal static let useRefreshFor = Text.tr("Localizable", "use_refresh_for")
  /// Wake up
  internal static let wakeUp = Text.tr("Localizable", "wake_up")
  /// Yesterday
  internal static let yesterday = Text.tr("Localizable", "yesterday")
  /// You don't have a schedule yet
  internal static let youDontHaveAScheduleYet = Text.tr("Localizable", "you_dont_have_a_schedule_yet")

  internal enum About {
    internal enum Feedback {
      /// Leave Feedback
      internal static let mail = Text.tr("Localizable", "about.feedback.mail")
    }
    internal enum Legal {
      /// License and Open Source Notes
      internal static let openSource = Text.tr("Localizable", "about.legal.open_source")
      /// Privacy Policy
      internal static let privacyPolicy = Text.tr("Localizable", "about.legal.privacy_policy")
      /// Terms and Conditions
      internal static let termsAndConditions = Text.tr("Localizable", "about.legal.terms_and_conditions")
    }
    internal enum Social {
      /// Source code on GitHub
      internal static let github = Text.tr("Localizable", "about.social.github")
      /// Reach me via LinkedIn
      internal static let linkedIn = Text.tr("Localizable", "about.social.linked_in")
      /// Reach me via Telegram
      internal static let telegram = Text.tr("Localizable", "about.social.telegram")
    }
  }

  internal enum KeepAppOpenedSuggestion {
    /// Why stay on screen
    internal static let button = Text.tr("Localizable", "keep_app_opened_suggestion.button")
    /// Continue
    internal static let `continue` = Text.tr("Localizable", "keep_app_opened_suggestion.continue")
    /// Please do not close the app or lock your phone while you sleep
    internal static let description = Text.tr("Localizable", "keep_app_opened_suggestion.description")
    /// This is necessary for the correct functioning of the alarm clock when you wake up
    internal static let descriptionWhy = Text.tr("Localizable", "keep_app_opened_suggestion.description_why")
    /// Information
    internal static let title = Text.tr("Localizable", "keep_app_opened_suggestion.title")
    /// We suggest to leave the phone near the bed and keep it unlocked
    internal static let whereToPlacePhone = Text.tr("Localizable", "keep_app_opened_suggestion.where_to_place_phone")
  }

  internal enum Onboarding {
    /// Continue
    internal static let action = Text.tr("Localizable", "onboarding.action")
    /// Begin to Rise
    internal static let actionFinal = Text.tr("Localizable", "onboarding.action_final")
    /// Have you ever dreamed of waking up right on time?
    internal static let dreamedOfWakingUpInTime = Text.tr("Localizable", "onboarding.dreamed_of_waking_up_in_time")
    /// It happens with all of us
    internal static let itHappensWithAllOfUs = Text.tr("Localizable", "onboarding.it_happens_with_all_of_us")
    /// Missed an alarm and still woke up broken?
    internal static let missedAlarm = Text.tr("Localizable", "onboarding.missed_alarm")
    /// Personal sleep schedule assistant to help establish quality sleep
    internal static let personalAssistent = Text.tr("Localizable", "onboarding.personal_assistent")
    /// Adjust, secure and maintain a good sleep
    internal static let secureGoodSleep = Text.tr("Localizable", "onboarding.secure_good_sleep")
    internal enum Title {
      /// Have you scheduled it?
      internal static let haveYouScheduledIt = Text.tr("Localizable", "onboarding.title.have_you_scheduled_it")
      /// Meet Rise!
      internal static let meetRise = Text.tr("Localizable", "onboarding.title.meet_rise")
      /// Sleep is important
      internal static let sleepIsImportant = Text.tr("Localizable", "onboarding.title.sleep_is_important")
    }
  }

  internal enum PrepareMailError {
    /// Cannot send email. Make sure a mail app is installed
    internal static let cannotSend = Text.tr("Localizable", "prepare_mail_error.cannot_send")
  }

  internal enum Settings {
    internal enum Description {
      /// Learn more about Rise
      internal static let about = Text.tr("Localizable", "settings.description.about")
      /// Manually adjust Rise goals
      internal static let editSchedule = Text.tr("Localizable", "settings.description.edit_schedule")
      /// Update sunrise/sunset if your location changed
      internal static let refresh = Text.tr("Localizable", "settings.description.refresh")
      /// If forgot what it is all for
      internal static let showOnboarding = Text.tr("Localizable", "settings.description.show_onboarding")
    }
    internal enum Title {
      /// About
      internal static let about = Text.tr("Localizable", "settings.title.about")
      /// Edit schedule
      internal static let editSchedule = Text.tr("Localizable", "settings.title.edit_schedule")
      /// Refresh sun times
      internal static let refresh = Text.tr("Localizable", "settings.title.refresh")
      /// Show onboarding
      internal static let showOnboarding = Text.tr("Localizable", "settings.title.show_onboarding")
    }
  }
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name vertical_whitespace_opening_braces

// MARK: - Implementation Details

extension Text {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg...) -> String {
    let format = BundleToken.bundle.localizedString(forKey: key, value: nil, table: table)
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

// swiftlint:disable convenience_type
private final class BundleToken {
  static let bundle: Bundle = {
    #if SWIFT_PACKAGE
    return Bundle.module
    #else
    return Bundle(for: BundleToken.self)
    #endif
  }()
}
// swiftlint:enable convenience_type
