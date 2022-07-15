// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

// swiftlint:disable sorted_imports
import Foundation
import UIKit

// swiftlint:disable superfluous_disable_command
// swiftlint:disable file_length implicit_return

// MARK: - Storyboard Scenes

// swiftlint:disable explicit_type_interface identifier_name line_length type_body_length type_name
internal enum StoryboardScene {
  internal enum Auth: StoryboardType {
    internal static let storyboardName = "Auth"

    internal static let initialScene = InitialSceneType<iOStarter.LoginVC>(storyboard: Auth.self)
  }
  internal enum LaunchScreen: StoryboardType {
    internal static let storyboardName = "LaunchScreen"

    internal static let initialScene = InitialSceneType<UIKit.UIViewController>(storyboard: LaunchScreen.self)
  }
  internal enum Main: StoryboardType {
    internal static let storyboardName = "Main"

    internal static let initialScene = InitialSceneType<iOStarter.TabBarMenuVC>(storyboard: Main.self)

    internal static let tabBarMenuVC = SceneType<iOStarter.TabBarMenuVC>(storyboard: Main.self, identifier: "TabBarMenuVC")
  }
  internal enum Menu: StoryboardType {
    internal static let storyboardName = "Menu"

    internal static let initialScene = InitialSceneType<iOStarter.DetailVC>(storyboard: Menu.self)

    internal static let detailVC = SceneType<iOStarter.DetailVC>(storyboard: Menu.self, identifier: "DetailVC")

    internal static let gridNavigation = SceneType<UIKit.UINavigationController>(storyboard: Menu.self, identifier: "GridNavigation")

    internal static let gridVC = SceneType<iOStarter.GridVC>(storyboard: Menu.self, identifier: "GridVC")

    internal static let homeNavigation = SceneType<UIKit.UINavigationController>(storyboard: Menu.self, identifier: "HomeNavigation")

    internal static let tableNavigation = SceneType<UIKit.UINavigationController>(storyboard: Menu.self, identifier: "TableNavigation")

    internal static let tableVC = SceneType<iOStarter.TableVC>(storyboard: Menu.self, identifier: "TableVC")
  }
  internal enum Profile: StoryboardType {
    internal static let storyboardName = "Profile"

    internal static let initialScene = InitialSceneType<UIKit.UINavigationController>(storyboard: Profile.self)

    internal static let notLoginNavigation = SceneType<UIKit.UINavigationController>(storyboard: Profile.self, identifier: "NotLoginNavigation")

    internal static let profileNavigation = SceneType<UIKit.UINavigationController>(storyboard: Profile.self, identifier: "ProfileNavigation")

    internal static let profileVC = SceneType<iOStarter.ProfileVC>(storyboard: Profile.self, identifier: "ProfileVC")
  }
}
// swiftlint:enable explicit_type_interface identifier_name line_length type_body_length type_name

// MARK: - Implementation Details

internal protocol StoryboardType {
  static var storyboardName: String { get }
}

internal extension StoryboardType {
  static var storyboard: UIStoryboard {
    let name = self.storyboardName
    return UIStoryboard(name: name, bundle: BundleToken.bundle)
  }
}

internal struct SceneType<T: UIViewController> {
  internal let storyboard: StoryboardType.Type
  internal let identifier: String

  internal func instantiate() -> T {
    let identifier = self.identifier
    guard let controller = storyboard.storyboard.instantiateViewController(withIdentifier: identifier) as? T else {
      fatalError("ViewController '\(identifier)' is not of the expected class \(T.self).")
    }
    return controller
  }

  @available(iOS 13.0, tvOS 13.0, *)
  internal func instantiate(creator block: @escaping (NSCoder) -> T?) -> T {
    return storyboard.storyboard.instantiateViewController(identifier: identifier, creator: block)
  }
}

internal struct InitialSceneType<T: UIViewController> {
  internal let storyboard: StoryboardType.Type

  internal func instantiate() -> T {
    guard let controller = storyboard.storyboard.instantiateInitialViewController() as? T else {
      fatalError("ViewController is not of the expected class \(T.self).")
    }
    return controller
  }

  @available(iOS 13.0, tvOS 13.0, *)
  internal func instantiate(creator block: @escaping (NSCoder) -> T?) -> T {
    guard let controller = storyboard.storyboard.instantiateInitialViewController(creator: block) else {
      fatalError("Storyboard \(storyboard.storyboardName) does not have an initial scene.")
    }
    return controller
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
