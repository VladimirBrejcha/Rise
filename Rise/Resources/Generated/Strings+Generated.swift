// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
internal enum Text {

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
