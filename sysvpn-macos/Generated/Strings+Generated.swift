// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return prefer_self_in_static_references

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
public enum L10n {
  public enum Global {
    /// Account
    public static let account = L10n.tr("Global", "account", fallback: "Account")
    /// Appearence
    public static let appearence = L10n.tr("Global", "appearence", fallback: "Appearence")
    /// General
    public static let general = L10n.tr("Global", "general", fallback: "General")
    /// Global.strings
    ///   sysvpn-macos
    /// 
    ///   Created by Nguyen Dinh Thach on 30/08/2022.
    public static let hello = L10n.tr("Global", "hello", fallback: "Hello")
    /// Help Center
    public static let helpCenter = L10n.tr("Global", "helpCenter", fallback: "Help Center")
    /// Location:
    public static let labelLocation = L10n.tr("Global", "labelLocation", fallback: "Location:")
    /// VPN IP:
    public static let labelVPNIP = L10n.tr("Global", "labelVPNIP", fallback: "VPN IP:")
    /// Location Map
    public static let locationMap = L10n.tr("Global", "locationMap", fallback: "Location Map")
    /// locations available
    public static let manualCDesc = L10n.tr("Global", "manualCDesc", fallback: "locations available")
    /// Manual connection
    public static let manualConnection = L10n.tr("Global", "manualConnection", fallback: "Manual connection")
    /// MultiHop
    public static let multiHop = L10n.tr("Global", "multiHop", fallback: "MultiHop")
    /// locations available
    public static let multiHopDesc = L10n.tr("Global", "multiHopDesc", fallback: "locations available")
    /// Quick
    /// Connect
    public static let quickConnect = L10n.tr("Global", "quickConnect", fallback: "Quick\nConnect")
    /// Settings
    public static let setting = L10n.tr("Global", "setting", fallback: "Settings")
    /// Static IP
    public static let staticIP = L10n.tr("Global", "staticIP", fallback: "Static IP")
    /// Personal Static IP address
    public static let staticIPDesc = L10n.tr("Global", "staticIPDesc", fallback: "Personal Static IP address")
    /// Statistics
    public static let statistics = L10n.tr("Global", "statistics", fallback: "Statistics")
    /// Support Center
    public static let supportCenter = L10n.tr("Global", "supportCenter", fallback: "Support Center")
    /// Sysvpn Configuration
    public static let sysvpnConfiguration = L10n.tr("Global", "sysvpnConfiguration", fallback: "Sysvpn Configuration")
    /// VPN Connected
    public static let vpnConnected = L10n.tr("Global", "vpnConnected", fallback: "VPN Connected")
    /// VPN not connected
    public static let vpnNotConnected = L10n.tr("Global", "vpnNotConnected", fallback: "VPN not connected")
    /// VPN Settings
    public static let vpnSetting = L10n.tr("Global", "vpnSetting", fallback: "VPN Settings")
  }
  public enum Login {
    /// All Country
    public static let allCountry = L10n.tr("Login", "allCountry", fallback: "All Country")
    /// SYSVPN
    public static let appName = L10n.tr("Login", "appName", fallback: "SYSVPN")
    /// Create New
    public static let createNew = L10n.tr("Login", "createNew", fallback: "Create New")
    /// Disconnect
    public static let disconnect = L10n.tr("Login", "disconnect", fallback: "Disconnect")
    /// Don’t have an account?
    public static let dontHaveAnAccount = L10n.tr("Login", "dontHaveAnAccount", fallback: "Don’t have an account?")
    /// Forgot password
    public static let forgotPassword = L10n.tr("Login", "forgotPassword", fallback: "Forgot password")
    /// Password
    public static let password = L10n.tr("Login", "password", fallback: "Password")
    /// Protected
    public static let protected = L10n.tr("Login", "protected", fallback: "Protected")
    /// Quick Connect
    public static let quickConnect = L10n.tr("Login", "quickConnect", fallback: "Quick Connect")
    /// Recent
    public static let recent = L10n.tr("Login", "recent", fallback: "Recent")
    /// Remember login
    public static let rememberLogin = L10n.tr("Login", "rememberLogin", fallback: "Remember login")
    /// Sign in
    public static let signIn = L10n.tr("Login", "signIn", fallback: "Sign in")
    /// Sign In with Apple ID
    public static let signInWithApple = L10n.tr("Login", "signInWithApple", fallback: "Sign In with Apple ID")
    /// Sign In with Google
    public static let signInWithGoogle = L10n.tr("Login", "signInWithGoogle", fallback: "Sign In with Google")
    /// Login.strings
    ///   sysvpn-macos
    /// 
    ///   Created by Nguyen Dinh Thach on 31/08/2022.
    public static let sologan = L10n.tr("Login", "sologan", fallback: "Start protecting yourself with SysVPN")
    /// Light is Faster, but We are Safer.
    public static let sologanProcessing = L10n.tr("Login", "sologanProcessing", fallback: "Light is Faster, but We are Safer.")
    /// Suggest
    public static let suggest = L10n.tr("Login", "suggest", fallback: "Suggest")
    /// Connect to VPN to online sercurity
    public static let titleNotConnect = L10n.tr("Login", "titleNotConnect", fallback: "Connect to VPN to online sercurity")
    /// Open
    public static let titleOpen = L10n.tr("Login", "titleOpen", fallback: "Open")
    /// Quit
    public static let titleQuit = L10n.tr("Login", "titleQuit", fallback: "Quit")
    /// Please try again!
    public static let tryAgain = L10n.tr("Login", "tryAgain", fallback: "Please try again!")
    /// Unprotected
    public static let unprotected = L10n.tr("Login", "unprotected", fallback: "Unprotected")
    /// Your email
    public static let yourEmail = L10n.tr("Login", "yourEmail", fallback: "Your email")
  }
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name vertical_whitespace_opening_braces

// MARK: - Implementation Details

extension L10n {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg..., fallback value: String) -> String {
    let format = BundleToken.bundle.localizedString(forKey: key, value: value, table: table)
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
