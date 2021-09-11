// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

#if os(macOS)
  import AppKit
#elseif os(iOS)
  import UIKit
#elseif os(tvOS) || os(watchOS)
  import UIKit
#endif

// Deprecated typealiases
@available(*, deprecated, renamed: "ColorAsset.Color", message: "This typealias will be removed in SwiftGen 7.0")
internal typealias AssetColorTypeAlias = ColorAsset.Color
@available(*, deprecated, renamed: "ImageAsset.Image", message: "This typealias will be removed in SwiftGen 7.0")
internal typealias AssetImageTypeAlias = ImageAsset.Image

// swiftlint:disable superfluous_disable_command file_length implicit_return

// MARK: - Asset Catalogs

// swiftlint:disable identifier_name line_length nesting type_body_length type_name
internal enum Asset {
  internal static let clock = ImageAsset(name: "Clock")
  internal enum Colors {
    internal enum BackgroundColors {
      internal static let defaultContainerBackground = ColorAsset(name: "DefaultContainerBackground")
    }
    internal enum ButtonStateColors {
      internal static let redTitle = ColorAsset(name: "redTitle")
    }
    internal enum Palette {
      internal static let violet = ColorAsset(name: "Violet")
    }
  }
  internal static let union = ImageAsset(name: "Union")
  internal static let union2 = ImageAsset(name: "Union2")
  internal static let alarm = ImageAsset(name: "alarm")
  internal static let alarmPressed = ImageAsset(name: "alarmPressed")
  internal enum Background {
    internal static let `default` = ImageAsset(name: "default")
    internal static let rich = ImageAsset(name: "rich")
  }
  internal static let bed = ImageAsset(name: "bed")
  internal static let beginToSleepIcon = ImageAsset(name: "beginToSleepIcon")
  internal static let calendar = ImageAsset(name: "calendar")
  internal static let cancel = ImageAsset(name: "cancel")
  internal static let check = ImageAsset(name: "check")
  internal static let fallasleep = ImageAsset(name: "fallasleep")
  internal static let launchScreenLogo = ImageAsset(name: "launchScreenLogo")
  internal static let settings = ImageAsset(name: "settings")
  internal static let settingsPressed = ImageAsset(name: "settingsPressed")
  internal static let sleepIcon = ImageAsset(name: "sleepIcon")
  internal static let sleepIconPressed = ImageAsset(name: "sleepIconPressed")
  internal static let sun = ImageAsset(name: "sun")
  internal static let sunrise = ImageAsset(name: "sunrise")
  internal static let sunset = ImageAsset(name: "sunset")
  internal static let tabBarBack = ImageAsset(name: "tabBarBack")
  internal static let time = ImageAsset(name: "time")
  internal static let timeSlot = ImageAsset(name: "timeSlot")
  internal static let wakeup = ImageAsset(name: "wakeup")
}
// swiftlint:enable identifier_name line_length nesting type_body_length type_name

// MARK: - Implementation Details

internal final class ColorAsset {
  internal fileprivate(set) var name: String

  #if os(macOS)
  internal typealias Color = NSColor
  #elseif os(iOS) || os(tvOS) || os(watchOS)
  internal typealias Color = UIColor
  #endif

  @available(iOS 11.0, tvOS 11.0, watchOS 4.0, macOS 10.13, *)
  internal private(set) lazy var color: Color = {
    guard let color = Color(asset: self) else {
      fatalError("Unable to load color asset named \(name).")
    }
    return color
  }()

  fileprivate init(name: String) {
    self.name = name
  }
}

internal extension ColorAsset.Color {
  @available(iOS 11.0, tvOS 11.0, watchOS 4.0, macOS 10.13, *)
  convenience init?(asset: ColorAsset) {
    let bundle = BundleToken.bundle
    #if os(iOS) || os(tvOS)
    self.init(named: asset.name, in: bundle, compatibleWith: nil)
    #elseif os(macOS)
    self.init(named: NSColor.Name(asset.name), bundle: bundle)
    #elseif os(watchOS)
    self.init(named: asset.name)
    #endif
  }
}

internal struct ImageAsset {
  internal fileprivate(set) var name: String

  #if os(macOS)
  internal typealias Image = NSImage
  #elseif os(iOS) || os(tvOS) || os(watchOS)
  internal typealias Image = UIImage
  #endif

  internal var image: Image {
    let bundle = BundleToken.bundle
    #if os(iOS) || os(tvOS)
    let image = Image(named: name, in: bundle, compatibleWith: nil)
    #elseif os(macOS)
    let name = NSImage.Name(self.name)
    let image = (bundle == .main) ? NSImage(named: name) : bundle.image(forResource: name)
    #elseif os(watchOS)
    let image = Image(named: name)
    #endif
    guard let result = image else {
      fatalError("Unable to load image asset named \(name).")
    }
    return result
  }
}

internal extension ImageAsset.Image {
  @available(macOS, deprecated,
    message: "This initializer is unsafe on macOS, please use the ImageAsset.image property")
  convenience init?(asset: ImageAsset) {
    #if os(iOS) || os(tvOS)
    let bundle = BundleToken.bundle
    self.init(named: asset.name, in: bundle, compatibleWith: nil)
    #elseif os(macOS)
    self.init(named: NSImage.Name(asset.name))
    #elseif os(watchOS)
    self.init(named: asset.name)
    #endif
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
