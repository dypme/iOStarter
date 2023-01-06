// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return prefer_self_in_static_references

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
internal enum L10n {
  /// Close
  internal static let close = L10n.tr("Localizable", "close", fallback: "Close")
  /// First Name
  internal static let firstName = L10n.tr("Localizable", "firstName", fallback: "First Name")
  /// Gender
  internal static let gender = L10n.tr("Localizable", "gender", fallback: "Gender")
  /// Hallo World
  internal static let halloWorld = L10n.tr("Localizable", "halloWorld", fallback: "Hallo World")
  /// Last Name
  internal static let lastName = L10n.tr("Localizable", "lastName", fallback: "Last Name")
  /// Login
  internal static let login = L10n.tr("Localizable", "login", fallback: "Login")
  /// Logout
  internal static let logout = L10n.tr("Localizable", "logout", fallback: "Logout")
  /// Password
  internal static let password = L10n.tr("Localizable", "password", fallback: "Password")
  internal enum Alert {
    /// OK
    internal static let actionButton = L10n.tr("Localizable", "alert.actionButton", fallback: "OK")
    /// Cancel
    internal static let cancelButton = L10n.tr("Localizable", "alert.cancelButton", fallback: "Cancel")
  }
  internal enum Button {
    /// Refresh
    internal static let refresh = L10n.tr("Localizable", "button.refresh", fallback: "Refresh")
  }
  internal enum Description {
    /// Are You sure want to logout?
    internal static let confirmLogout = L10n.tr("Localizable", "description.confirmLogout", fallback: "Are You sure want to logout?")
    /// Hallo, please login first
    internal static let login = L10n.tr("Localizable", "description.login", fallback: "Hallo, please login first")
  }
  internal enum Error {
    /// Please choose %@.
    internal static func chooseData(_ p1: Any) -> String {
      return L10n.tr("Localizable", "error.chooseData", String(describing: p1), fallback: "Please choose %@.")
    }
    /// Please complete required form.
    internal static let completeForm = L10n.tr("Localizable", "error.completeForm", fallback: "Please complete required form.")
    /// Please use a valid email.
    internal static let emailValidity = L10n.tr("Localizable", "error.emailValidity", fallback: "Please use a valid email.")
    /// Please input %@.
    internal static func inputData(_ p1: Any) -> String {
      return L10n.tr("Localizable", "error.inputData", String(describing: p1), fallback: "Please input %@.")
    }
    /// Password must be at least 1 numeric and 8 characters
    internal static let passwordValidity = L10n.tr("Localizable", "error.passwordValidity", fallback: "Password must be at least 1 numeric and 8 characters")
  }
  internal enum Menu {
    /// Components
    internal static let components = L10n.tr("Localizable", "menu.components", fallback: "Components")
    /// Grid
    internal static let grid = L10n.tr("Localizable", "menu.grid", fallback: "Grid")
    /// Home
    internal static let home = L10n.tr("Localizable", "menu.home", fallback: "Home")
    /// List
    internal static let list = L10n.tr("Localizable", "menu.list", fallback: "List")
    /// Profile
    internal static let profile = L10n.tr("Localizable", "menu.profile", fallback: "Profile")
  }
  internal enum PickerField {
    /// Cancel
    internal static let cancel = L10n.tr("Localizable", "pickerField.cancel", fallback: "Cancel")
    /// Choose
    internal static let choose = L10n.tr("Localizable", "pickerField.choose", fallback: "Choose")
  }
  internal enum Title {
    /// Example
    internal static let example = L10n.tr("Localizable", "title.example", fallback: "Example")
    /// Home
    internal static let home = L10n.tr("Localizable", "title.home", fallback: "Home")
    /// Not Login
    internal static let notLogin = L10n.tr("Localizable", "title.notLogin", fallback: "Not Login")
    /// Profile
    internal static let profile = L10n.tr("Localizable", "title.profile", fallback: "Profile")
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
