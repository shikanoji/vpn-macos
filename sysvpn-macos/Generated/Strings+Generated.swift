// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return prefer_self_in_static_references

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
public enum L10n {
  public enum Global {
    /// Global.strings
    ///   sysvpn-macos
    /// 
    ///   Created by Nguyen Dinh Thach on 30/08/2022.
    public static let hello = L10n.tr("Global", "hello", fallback: "Hello")
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
