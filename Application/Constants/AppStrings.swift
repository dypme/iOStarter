// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation
import L10n_swift

// swiftlint:disable superfluous_disable_command
// swiftlint:disable file_length

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name
internal enum L10n {
  /// Hallo World
  internal static var halloWorld: String { return L10n.tr("Localizable", "halloWorld") }

  internal enum Alert {
    /// Please input %@
    internal static func inputField(_ p1: String) -> String {
      return L10n.tr("Localizable", "alert.inputField", p1)
    }
    /// Attention
    internal static var title: String { return L10n.tr("Localizable", "alert.title") }
  }

  internal enum PickerField {
    /// Cancel
    internal static var cancel: String { return L10n.tr("Localizable", "pickerField.cancel") }
    /// Select
    internal static var select: String { return L10n.tr("Localizable", "pickerField.select") }
  }
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name

// MARK: - Implementation Details

extension L10n {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg...) -> String {
    // swiftlint:disable:next nslocalizedstring_key
    return key.l10n(.shared, resource: table, fittingWidth: nil, args: args)
  }
}

private final class BundleToken {}
