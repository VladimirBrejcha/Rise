// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
public enum Text {
  /// Adjust schedule
  public static let adjustSchedule = Text.tr("Localizable", "adjust_schedule")
  /// The next bedtime will be changed to 
  public static let adjustScheduleNextSleep = Text.tr("Localizable", "adjust_schedule_next_sleep")
  /// If you missed sleep
  public static let adjustScheduleShortDescription = Text.tr("Localizable", "adjust_schedule_short_description")
  /// You can update Rise schedule to better match your current situation if you missed your bedtime. Remember, there is no need to rush, a good sleep requires careful attention.
  public static let adjustScheduleSuggestionToAdjust = Text.tr("Localizable", "adjust_schedule_suggestion_to_adjust")
  /// Would you like to update your schedule to better fit your last sleep?
  public static let adjustScheduleWannaAdjust = Text.tr("Localizable", "adjust_schedule_wanna_adjust")
  /// An internal error occurred
  public static let anInternalErrorOccurred = Text.tr("Localizable", "an_internal_error_occurred")
  /// Edit Rise schedule
  public static let editRiseSchedule = Text.tr("Localizable", "edit_rise_schedule")
  /// Failed to load time
  public static let failedToLoadTime = Text.tr("Localizable", "failed_to_load_time")
  /// It's time to sleep!
  public static let itsTimeToSleep = Text.tr("Localizable", "its_time_to_sleep!")
  /// Next bedtime
  public static let lastTimeIWentSleepAt = Text.tr("Localizable", "last_time_i_went_sleep_at")
  /// Location access is required to perform refresh
  public static let locationAccessIsRequiredToPerformRefresh = Text.tr("Localizable", "location_access_is_required_to_perform_refresh")
  /// Location access missing
  public static let locationAccessMissing = Text.tr("Localizable", "location_access_missing")
  /// No schedule for the day
  public static let noScheduleForTheDay = Text.tr("Localizable", "no_schedule_for_the_day")
  /// Refresh
  public static let refresh = Text.tr("Localizable", "refresh")
  /// Refresh sun times
  public static let refreshSunTimes = Text.tr("Localizable", "refresh_sun_times")
  /// We store sunrises and sunsets on the device to provide fast and energy efficient access times even offline
  public static let refreshSunTimesDescription = Text.tr("Localizable", "refresh_sun_times_description")
  /// Rise schedule is paused
  public static let riseScheduleIsPaused = Text.tr("Localizable", "rise_schedule_is_paused")
  /// Save
  public static let save = Text.tr("Localizable", "save")
  /// Scheduled sleep
  public static let scheduledSleep = Text.tr("Localizable", "scheduled_sleep")
  /// Sleep
  public static let sleep = Text.tr("Localizable", "sleep")
  /// Sleep in just a %@ mins
  public static func sleepInJustAFew(_ p1: Any) -> String {
    return Text.tr("Localizable", "sleep_in_just_a_few", String(describing: p1))
  }
  /// Sleep is scheduled in %@
  public static func sleepIsScheduledIn(_ p1: Any) -> String {
    return Text.tr("Localizable", "sleep_is_scheduled_in", String(describing: p1))
  }
  /// Sleeping
  public static let sleeping = Text.tr("Localizable", "sleeping")
  /// Hold to stop
  public static let stop = Text.tr("Localizable", "stop")
  /// Success!
  public static let success = Text.tr("Localizable", "success")
  /// Sun position
  public static let sunPosition = Text.tr("Localizable", "sun_position")
  /// Sunrise
  public static let sunrise = Text.tr("Localizable", "sunrise")
  /// Sunset
  public static let sunset = Text.tr("Localizable", "sunset")
  /// Time not found
  public static let timeNotFound = Text.tr("Localizable", "time_not_found")
  /// To bed
  public static let toBed = Text.tr("Localizable", "to_bed")
  /// Today
  public static let today = Text.tr("Localizable", "today")
  /// Tomorrow
  public static let tomorrow = Text.tr("Localizable", "tomorrow")
  /// In case if your location changed use refresh to update it with actual data
  public static let useRefreshFor = Text.tr("Localizable", "use_refresh_for")
  /// Wake up
  public static let wakeUp = Text.tr("Localizable", "wake_up")
  /// Yesterday
  public static let yesterday = Text.tr("Localizable", "yesterday")
  /// You don't have a schedule yet
  public static let youDontHaveAScheduleYet = Text.tr("Localizable", "you_dont_have_a_schedule_yet")

  public enum About {
    public enum Coauthors {
      /// Nouble Bushido
      public static let noubleBushido = Text.tr("Localizable", "about.coauthors.noubleBushido")
      /// Vladimir Brejcha
      public static let vladimirBrejcha = Text.tr("Localizable", "about.coauthors.vladimirBrejcha")
      /// Vladislav
      public static let vladislav = Text.tr("Localizable", "about.coauthors.vladislav")
    }
    public enum Feedback {
      /// Leave Feedback
      public static let mail = Text.tr("Localizable", "about.feedback.mail")
    }
    public enum Legal {
      /// License and Open Source Notes
      public static let openSource = Text.tr("Localizable", "about.legal.open_source")
      /// Privacy Policy
      public static let privacyPolicy = Text.tr("Localizable", "about.legal.privacy_policy")
      /// Terms and Conditions
      public static let termsAndConditions = Text.tr("Localizable", "about.legal.terms_and_conditions")
    }
    public enum Social {
      /// Source code on GitHub
      public static let github = Text.tr("Localizable", "about.social.github")
      /// Reach me via LinkedIn
      public static let linkedIn = Text.tr("Localizable", "about.social.linked_in")
      /// Reach me via Telegram
      public static let telegram = Text.tr("Localizable", "about.social.telegram")
    }
  }

  public enum AfterSleep {
    /// Done
    public static let done = Text.tr("Localizable", "after_sleep.done")
    /// Good morning!
    public static let mainText = Text.tr("Localizable", "after_sleep.main_text")
    /// Sleep finished
    public static let title = Text.tr("Localizable", "after_sleep.title")
    /// Sleep ended
    public static let titleSleepStopped = Text.tr("Localizable", "after_sleep.title_sleep_stopped")
  }

  public enum Alarming {
    /// Snooze
    public static let snooze = Text.tr("Localizable", "alarming.snooze")
    /// Wake up
    public static let stop = Text.tr("Localizable", "alarming.stop")
    /// Wake up and Rise!
    public static let title = Text.tr("Localizable", "alarming.title")
  }

  public enum KeepAppOpenedSuggestion {
    /// Why stay on screen
    public static let button = Text.tr("Localizable", "keep_app_opened_suggestion.button")
    /// Continue
    public static let `continue` = Text.tr("Localizable", "keep_app_opened_suggestion.continue")
    /// Please do not close the app or lock your phone while you sleep
    public static let description = Text.tr("Localizable", "keep_app_opened_suggestion.description")
    /// This is necessary for the correct functioning of the alarm clock when you wake up
    public static let descriptionWhy = Text.tr("Localizable", "keep_app_opened_suggestion.description_why")
    /// Information
    public static let title = Text.tr("Localizable", "keep_app_opened_suggestion.title")
    /// We suggest to leave the phone near the bed and keep it unlocked
    public static let whereToPlacePhone = Text.tr("Localizable", "keep_app_opened_suggestion.where_to_place_phone")
  }

  public enum Onboarding {
    /// Continue
    public static let action = Text.tr("Localizable", "onboarding.action")
    /// Begin to Rise
    public static let actionFinal = Text.tr("Localizable", "onboarding.action_final")
    public enum Page1 {
      /// Created from personal struggles with sleep, Rise is here to help you achieve healthier, more refreshing sleep.
      public static let body = Text.tr("Localizable", "onboarding.page1.body")
      /// Welcome to Rise!
      public static let title = Text.tr("Localizable", "onboarding.page1.title")
    }
    public enum Page2 {
      /// Rise creates a unique sleep schedule for you, based on your desired wake-up time and sleep duration, gradually nudging you towards your goals.
      public static let body = Text.tr("Localizable", "onboarding.page2.body")
      /// Your Tailored Sleep Schedule
      public static let title = Text.tr("Localizable", "onboarding.page2.title")
    }
    public enum Page3 {
      /// Using your location, Rise provides sunrise and sunset times, helping you align your sleep with the day's natural light.
      public static let body = Text.tr("Localizable", "onboarding.page3.body")
      /// Nature's Rhythm
      public static let title = Text.tr("Localizable", "onboarding.page3.title")
    }
    public enum Page4 {
      /// No more rude awakenings. Rise uses soft nature sounds that gradually increase, waking you up gently for a better start to your day.
      public static let body = Text.tr("Localizable", "onboarding.page4.body")
      /// A Soothing Start
      public static let title = Text.tr("Localizable", "onboarding.page4.title")
    }
    public enum Page5 {
      /// To fully guide you on this journey to improved sleep, Rise needs your permission for notifications. Let's embark on this sleep-enhancing adventure together.
      public static let body = Text.tr("Localizable", "onboarding.page5.body")
      /// Let's Rise Together!
      public static let title = Text.tr("Localizable", "onboarding.page5.title")
    }
  }

  public enum PrepareMailError {
    /// Cannot send email. Make sure a mail app is installed
    public static let cannotSend = Text.tr("Localizable", "prepare_mail_error.cannot_send")
  }

  public enum Settings {
    public enum Description {
      /// Learn more about Rise
      public static let about = Text.tr("Localizable", "settings.description.about")
      /// Manually adjust Rise goals
      public static let editSchedule = Text.tr("Localizable", "settings.description.edit_schedule")
      /// Update sunrise/sunset if your location changed
      public static let refresh = Text.tr("Localizable", "settings.description.refresh")
      /// If forgot what it is all for
      public static let showOnboarding = Text.tr("Localizable", "settings.description.show_onboarding")
    }
    public enum Title {
      /// About
      public static let about = Text.tr("Localizable", "settings.title.about")
      /// Edit schedule
      public static let editSchedule = Text.tr("Localizable", "settings.title.edit_schedule")
      /// Refresh sun times
      public static let refresh = Text.tr("Localizable", "settings.title.refresh")
      /// Show onboarding
      public static let showOnboarding = Text.tr("Localizable", "settings.title.show_onboarding")
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
