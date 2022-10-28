// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

#if os(macOS)
  import AppKit
#elseif os(iOS)
  import UIKit
#elseif os(tvOS) || os(watchOS)
  import UIKit
#endif
#if canImport(SwiftUI)
  import SwiftUI
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
  internal enum Assets {
    internal static let accentColor = ColorAsset(name: "AccentColor")
    internal static let logo = ImageAsset(name: "Logo")
    internal static let avatarTest = ImageAsset(name: "avatar_test")
    internal static let bgLoading = ImageAsset(name: "bg_loading")
    internal static let bgTabbar = ImageAsset(name: "bg_tabbar")
    internal static let demoCountry = ImageAsset(name: "demo_country")
    internal static let icAlertError = ImageAsset(name: "ic_alert_error")
    internal static let icApple = ImageAsset(name: "ic_apple")
    internal static let icArrowDown = ImageAsset(name: "ic_arrow_down")
    internal static let icArrowLeft = ImageAsset(name: "ic_arrow_left")
    internal static let icArrowRight = ImageAsset(name: "ic_arrow_right")
    internal static let icArrowUp = ImageAsset(name: "ic_arrow_up")
    internal static let icCheckChecked = ImageAsset(name: "ic_check_checked")
    internal static let icCheckNormal = ImageAsset(name: "ic_check_normal")
    internal static let icClose = ImageAsset(name: "ic_close")
    internal static let icDecZoom = ImageAsset(name: "ic_dec_zoom")
    internal static let icFlagEmpty = ImageAsset(name: "ic_flag_empty")
    internal static let icGoogle = ImageAsset(name: "ic_google")
    internal static let icIncZoom = ImageAsset(name: "ic_inc_zoom")
    internal static let icIpAddress = ImageAsset(name: "ic_ip_address")
    internal static let icLink = ImageAsset(name: "ic_link")
    internal static let icLocation = ImageAsset(name: "ic_location")
    internal static let icLogoApp = ImageAsset(name: "ic_logo_app")
    internal static let icLogoWhite = ImageAsset(name: "ic_logo_white")
    internal static let icMapLocation = ImageAsset(name: "ic_map_location")
    internal static let icMini = ImageAsset(name: "ic_mini")
    internal static let icNode = ImageAsset(name: "ic_node")
    internal static let icNodeActive = ImageAsset(name: "ic_node_active")
    internal static let icNodeActiveDisabled = ImageAsset(name: "ic_node_active_disabled")
    internal static let icNodeDisabled = ImageAsset(name: "ic_node_disabled")
    internal static let icOff = ImageAsset(name: "ic_off")
    internal static let icPower = ImageAsset(name: "ic_power")
    internal static let icSend = ImageAsset(name: "ic_send")
    internal static let icSetting = ImageAsset(name: "ic_setting")
    internal static let icStaticServer = ImageAsset(name: "ic_static_server")
    internal static let icUnprotected = ImageAsset(name: "ic_unprotected")
    internal static let logoF1 = ImageAsset(name: "logo_f1")
    internal static let mapLayer1 = ImageAsset(name: "map_layer1")
  }
  internal enum Colors {
    internal static let primaryColor = ColorAsset(name: " primaryColor")
    internal static let backgroundButtonDisable = ColorAsset(name: "backgroundButtonDisable")
    internal static let backgroundColor = ColorAsset(name: "backgroundColor")
    internal static let bodySettingColor = ColorAsset(name: "bodySettingColor")
    internal static let borderColor = ColorAsset(name: "borderColor")
    internal static let errorColor = ColorAsset(name: "errorColor")
    internal static let foregroundButtonDisable = ColorAsset(name: "foregroundButtonDisable")
    internal static let foregroundButtonEnable = ColorAsset(name: "foregroundButtonEnable")
    internal static let headerSettingColor = ColorAsset(name: "headerSettingColor")
    internal static let infoColor = ColorAsset(name: "infoColor")
    internal static let mainBackgroundColor = ColorAsset(name: "mainBackgroundColor")
    internal static let mainLinearEndColor = ColorAsset(name: "mainLinearEndColor")
    internal static let mainLinearStartColor = ColorAsset(name: "mainLinearStartColor")
    internal static let mainTextColor = ColorAsset(name: "mainTextColor")
    internal static let outlightColor = ColorAsset(name: "outlightColor")
    internal static let secondary = ColorAsset(name: "secondary")
    internal static let subTextColor = ColorAsset(name: "subTextColor")
    internal static let successColor = ColorAsset(name: "successColor")
    internal static let textErrorColor = ColorAsset(name: "textErrorColor")
    internal static let themeColor = ColorAsset(name: "themeColor")
    internal static let warningColor = ColorAsset(name: "warningColor")
  }
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

  #if os(iOS) || os(tvOS)
  @available(iOS 11.0, tvOS 11.0, *)
  internal func color(compatibleWith traitCollection: UITraitCollection) -> Color {
    let bundle = BundleToken.bundle
    guard let color = Color(named: name, in: bundle, compatibleWith: traitCollection) else {
      fatalError("Unable to load color asset named \(name).")
    }
    return color
  }
  #endif

  #if canImport(SwiftUI)
  @available(iOS 13.0, tvOS 13.0, watchOS 6.0, macOS 10.15, *)
  internal private(set) lazy var swiftUIColor: SwiftUI.Color = {
    SwiftUI.Color(asset: self)
  }()
  #endif

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

#if canImport(SwiftUI)
@available(iOS 13.0, tvOS 13.0, watchOS 6.0, macOS 10.15, *)
internal extension SwiftUI.Color {
  init(asset: ColorAsset) {
    let bundle = BundleToken.bundle
    self.init(asset.name, bundle: bundle)
  }
}
#endif

internal struct ImageAsset {
  internal fileprivate(set) var name: String

  #if os(macOS)
  internal typealias Image = NSImage
  #elseif os(iOS) || os(tvOS) || os(watchOS)
  internal typealias Image = UIImage
  #endif

  @available(iOS 8.0, tvOS 9.0, watchOS 2.0, macOS 10.7, *)
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

  #if os(iOS) || os(tvOS)
  @available(iOS 8.0, tvOS 9.0, *)
  internal func image(compatibleWith traitCollection: UITraitCollection) -> Image {
    let bundle = BundleToken.bundle
    guard let result = Image(named: name, in: bundle, compatibleWith: traitCollection) else {
      fatalError("Unable to load image asset named \(name).")
    }
    return result
  }
  #endif

  #if canImport(SwiftUI)
  @available(iOS 13.0, tvOS 13.0, watchOS 6.0, macOS 10.15, *)
  internal var swiftUIImage: SwiftUI.Image {
    SwiftUI.Image(asset: self)
  }
  #endif
}

internal extension ImageAsset.Image {
  @available(iOS 8.0, tvOS 9.0, watchOS 2.0, *)
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

#if canImport(SwiftUI)
@available(iOS 13.0, tvOS 13.0, watchOS 6.0, macOS 10.15, *)
internal extension SwiftUI.Image {
  init(asset: ImageAsset) {
    let bundle = BundleToken.bundle
    self.init(asset.name, bundle: bundle)
  }

  init(asset: ImageAsset, label: Text) {
    let bundle = BundleToken.bundle
    self.init(asset.name, bundle: bundle, label: label)
  }

  init(decorative asset: ImageAsset) {
    let bundle = BundleToken.bundle
    self.init(decorative: asset.name, bundle: bundle)
  }
}
#endif

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
