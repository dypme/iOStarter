// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
internal enum L10n {
  /// Close
  internal static let close = L10n.tr("Localizable", "close")
  /// First Name
  internal static let firstName = L10n.tr("Localizable", "firstName")
  /// Gender
  internal static let gender = L10n.tr("Localizable", "gender")
  /// Hallo World
  internal static let halloWorld = L10n.tr("Localizable", "halloWorld")
  /// Last Name
  internal static let lastName = L10n.tr("Localizable", "lastName")
  /// Login
  internal static let login = L10n.tr("Localizable", "login")
  /// Logout
  internal static let logout = L10n.tr("Localizable", "logout")
  /// Password
  internal static let password = L10n.tr("Localizable", "password")

  internal enum Alert {
    /// OK
    internal static let actionButton = L10n.tr("Localizable", "alert.actionButton")
    /// Cancel
    internal static let cancelButton = L10n.tr("Localizable", "alert.cancelButton")
  }

  internal enum Button {
    /// Refresh
    internal static let refresh = L10n.tr("Localizable", "button.refresh")
  }

  internal enum Description {
    /// Are You sure want to logout?
    internal static let confirmLogout = L10n.tr("Localizable", "description.confirmLogout")
    /// Hallo, please login first
    internal static let login = L10n.tr("Localizable", "description.login")
  }

  internal enum Error {
    /// Please choose %@.
    internal static func chooseData(_ p1: Any) -> String {
      return L10n.tr("Localizable", "error.chooseData", String(describing: p1))
    }
    /// Please complete required form.
    internal static let completeForm = L10n.tr("Localizable", "error.completeForm")
    /// Please use a valid email.
    internal static let emailValidity = L10n.tr("Localizable", "error.emailValidity")
    /// Please input %@.
    internal static func inputData(_ p1: Any) -> String {
      return L10n.tr("Localizable", "error.inputData", String(describing: p1))
    }
    /// Password must be at least 1 numeric and 8 characters
    internal static let passwordValidity = L10n.tr("Localizable", "error.passwordValidity")
  }

  internal enum Menu {
    /// Home
    internal static let home = L10n.tr("Localizable", "menu.home")
    /// List %@
    internal static func list(_ p1: Any) -> String {
      return L10n.tr("Localizable", "menu.list", String(describing: p1))
    }
    /// Profile
    internal static let profile = L10n.tr("Localizable", "menu.profile")
  }

  internal enum PickerField {
    /// Cancel
    internal static let cancel = L10n.tr("Localizable", "pickerField.cancel")
    /// Choose
    internal static let choose = L10n.tr("Localizable", "pickerField.choose")
  }

  internal enum Title {
    /// Example
    internal static let example = L10n.tr("Localizable", "title.example")
    /// Home
    internal static let home = L10n.tr("Localizable", "title.home")
    /// Not Login
    internal static let notLogin = L10n.tr("Localizable", "title.notLogin")
    /// Profile
    internal static let profile = L10n.tr("Localizable", "title.profile")
  }
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name vertical_whitespace_opening_braces

// MARK: - Implementation Details

extension L10n {
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
