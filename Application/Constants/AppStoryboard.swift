// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

// swiftlint:disable sorted_imports
import Foundation
import UIKit

// swiftlint:disable superfluous_disable_command
// swiftlint:disable file_length

// MARK: - Storyboard Scenes

// swiftlint:disable explicit_type_interface identifier_name line_length type_body_length type_name
internal enum StoryboardScene {
  internal enum Auth: StoryboardType {
    internal static let storyboardName = "Auth"

    internal static let initialScene = InitialSceneType<iOStarter.LoginVC>(storyboard: Auth.self)

    internal static let forgotPassVC = SceneType<iOStarter.ForgotPassVC>(storyboard: Auth.self, identifier: "ForgotPassVC")

    internal static let loginVC = SceneType<iOStarter.LoginVC>(storyboard: Auth.self, identifier: "LoginVC")

    internal static let registerVC = SceneType<iOStarter.RegisterVC>(storyboard: Auth.self, identifier: "RegisterVC")
  }
  internal enum Example: StoryboardType {
    internal static let storyboardName = "Example"

    internal static let initialScene = InitialSceneType<UIKit.UINavigationController>(storyboard: Example.self)

    internal static let exampleDetailVC = SceneType<iOStarter.ExampleDetailVC>(storyboard: Example.self, identifier: "ExampleDetailVC")

    internal static let exampleListVC = SceneType<iOStarter.ExampleListVC>(storyboard: Example.self, identifier: "ExampleListVC")

    internal static let exampleListVCNav = SceneType<UIKit.UINavigationController>(storyboard: Example.self, identifier: "ExampleListVCNav")
  }
  internal enum LaunchScreen: StoryboardType {
    internal static let storyboardName = "LaunchScreen"

    internal static let initialScene = InitialSceneType<UIKit.UIViewController>(storyboard: LaunchScreen.self)
  }
  internal enum Main: StoryboardType {
    internal static let storyboardName = "Main"

    internal static let initialScene = InitialSceneType<UIKit.UINavigationController>(storyboard: Main.self)

    internal static let drawerMenuVC = SceneType<iOStarter.DrawerMenuVC>(storyboard: Main.self, identifier: "DrawerMenuVC")

    internal static let gridMenuVC = SceneType<iOStarter.GridMenuVC>(storyboard: Main.self, identifier: "GridMenuVC")

    internal static let gridMenuVCNav = SceneType<UIKit.UINavigationController>(storyboard: Main.self, identifier: "GridMenuVCNav")

    internal static let tabBarMenuVC = SceneType<iOStarter.TabBarMenuVC>(storyboard: Main.self, identifier: "TabBarMenuVC")

    internal static let tabBarMenuVCNav = SceneType<UIKit.UINavigationController>(storyboard: Main.self, identifier: "TabBarMenuVCNav")

    internal static let viewController = SceneType<iOStarter.ViewController>(storyboard: Main.self, identifier: "ViewController")

    internal static let viewControllerNav = SceneType<UIKit.UINavigationController>(storyboard: Main.self, identifier: "ViewControllerNav")
  }
  internal enum Profile: StoryboardType {
    internal static let storyboardName = "Profile"

    internal static let initialScene = InitialSceneType<UIKit.UINavigationController>(storyboard: Profile.self)

    internal static let editPassVC = SceneType<iOStarter.EditPassVC>(storyboard: Profile.self, identifier: "EditPassVC")

    internal static let editProfileVC = SceneType<iOStarter.EditProfileVC>(storyboard: Profile.self, identifier: "EditProfileVC")

    internal static let profileVC = SceneType<iOStarter.ProfileVC>(storyboard: Profile.self, identifier: "ProfileVC")

    internal static let profileVCNav = SceneType<UIKit.UINavigationController>(storyboard: Profile.self, identifier: "ProfileVCNav")
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
    return UIStoryboard(name: name, bundle: Bundle(for: BundleToken.self))
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
}

internal struct InitialSceneType<T: UIViewController> {
  internal let storyboard: StoryboardType.Type

  internal func instantiate() -> T {
    guard let controller = storyboard.storyboard.instantiateInitialViewController() as? T else {
      fatalError("ViewController is not of the expected class \(T.self).")
    }
    return controller
  }
}

private final class BundleToken {}
