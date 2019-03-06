// Generated using SwiftGen, by O.Halligon — https://github.com/SwiftGen/SwiftGen

// swiftlint:disable sorted_imports
import Foundation
import UIKit

// swiftlint:disable superfluous_disable_command
// swiftlint:disable file_length

internal protocol StoryboardType {
  static var storyboardName: String { get }
}

internal extension StoryboardType {
  static var storyboard: UIStoryboard {
    let name = self.storyboardName
    return UIStoryboard(name: name, bundle: Bundle(for: BundleToken.self))
  }
}

internal struct SceneType<T: Any> {
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

internal struct InitialSceneType<T: Any> {
  internal let storyboard: StoryboardType.Type

  internal func instantiate() -> T {
    guard let controller = storyboard.storyboard.instantiateInitialViewController() as? T else {
      fatalError("ViewController is not of the expected class \(T.self).")
    }
    return controller
  }
}

internal protocol SegueType: RawRepresentable { }

internal extension UIViewController {
  func perform<S: SegueType>(segue: S, sender: Any? = nil) where S.RawValue == String {
    let identifier = segue.rawValue
    performSegue(withIdentifier: identifier, sender: sender)
  }
}

// swiftlint:disable explicit_type_interface identifier_name line_length type_body_length type_name
internal enum StoryboardScene {
  internal enum Auth: StoryboardType {
    internal static let storyboardName = "Auth"

    internal static let initialScene = InitialSceneType<iOS_Starter.LoginVC>(storyboard: Auth.self)

    internal static let forgotPassVC = SceneType<iOS_Starter.ForgotPassVC>(storyboard: Auth.self, identifier: "ForgotPassVC")

    internal static let loginVC = SceneType<iOS_Starter.LoginVC>(storyboard: Auth.self, identifier: "LoginVC")

    internal static let registerVC = SceneType<iOS_Starter.RegisterVC>(storyboard: Auth.self, identifier: "RegisterVC")
  }
  internal enum LaunchScreen: StoryboardType {
    internal static let storyboardName = "LaunchScreen"

    internal static let initialScene = InitialSceneType<UIViewController>(storyboard: LaunchScreen.self)
  }
  internal enum Main: StoryboardType {
    internal static let storyboardName = "Main"

    internal static let initialScene = InitialSceneType<UINavigationController>(storyboard: Main.self)

    internal static let drawerMenuVC = SceneType<iOS_Starter.DrawerMenuVC>(storyboard: Main.self, identifier: "DrawerMenuVC")

    internal static let gridMenuVC = SceneType<iOS_Starter.GridMenuVC>(storyboard: Main.self, identifier: "GridMenuVC")

    internal static let gridMenuVCNav = SceneType<UINavigationController>(storyboard: Main.self, identifier: "GridMenuVCNav")

    internal static let tabBarMenuVC = SceneType<iOS_Starter.TabBarMenuVC>(storyboard: Main.self, identifier: "TabBarMenuVC")

    internal static let tabBarMenuVCNav = SceneType<UINavigationController>(storyboard: Main.self, identifier: "TabBarMenuVCNav")

    internal static let viewController = SceneType<iOS_Starter.ViewController>(storyboard: Main.self, identifier: "ViewController")

    internal static let viewControllerNav = SceneType<UINavigationController>(storyboard: Main.self, identifier: "ViewControllerNav")
  }
  internal enum Profile: StoryboardType {
    internal static let storyboardName = "Profile"

    internal static let initialScene = InitialSceneType<UINavigationController>(storyboard: Profile.self)

    internal static let editPassVC = SceneType<iOS_Starter.EditPassVC>(storyboard: Profile.self, identifier: "EditPassVC")

    internal static let editProfileVC = SceneType<iOS_Starter.EditProfileVC>(storyboard: Profile.self, identifier: "EditProfileVC")

    internal static let profileVC = SceneType<iOS_Starter.ProfileVC>(storyboard: Profile.self, identifier: "ProfileVC")

    internal static let profileVCNav = SceneType<UINavigationController>(storyboard: Profile.self, identifier: "ProfileVCNav")
  }
  internal enum TabStripPager: StoryboardType {
    internal static let storyboardName = "TabStripPager"

    internal static let initialScene = InitialSceneType<UINavigationController>(storyboard: TabStripPager.self)

    internal static let tabStripPagerVC = SceneType<iOS_Starter.TabStripPagerVC>(storyboard: TabStripPager.self, identifier: "TabStripPagerVC")

    internal static let tabStripPagerVCNav = SceneType<UINavigationController>(storyboard: TabStripPager.self, identifier: "TabStripPagerVCNav")
  }
  internal enum TemplateContent: StoryboardType {
    internal static let storyboardName = "TemplateContent"

    internal static let initialScene = InitialSceneType<UINavigationController>(storyboard: TemplateContent.self)

    internal static let templateContentDetailVC = SceneType<iOS_Starter.TemplateContentDetailVC>(storyboard: TemplateContent.self, identifier: "TemplateContentDetailVC")

    internal static let templateContentListVC = SceneType<iOS_Starter.TemplateContentListVC>(storyboard: TemplateContent.self, identifier: "TemplateContentListVC")

    internal static let templateContentListVCNav = SceneType<UINavigationController>(storyboard: TemplateContent.self, identifier: "TemplateContentListVCNav")
  }
}

internal enum StoryboardSegue {
}
// swiftlint:enable explicit_type_interface identifier_name line_length type_body_length type_name

private final class BundleToken {}
