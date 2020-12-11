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
@available(*, deprecated, renamed: "ImageAsset.Image", message: "This typealias will be removed in SwiftGen 7.0")
internal typealias AssetImageTypeAlias = ImageAsset.Image

// swiftlint:disable superfluous_disable_command file_length implicit_return

// MARK: - Asset Catalogs

// swiftlint:disable identifier_name line_length nesting type_body_length type_name
internal enum Asset {
  internal static let blankImage = ImageAsset(name: "blank_image")
  internal static let icBack = ImageAsset(name: "ic-back")
  internal static let icAccount = ImageAsset(name: "ic_account")
  internal static let icCameraClose = ImageAsset(name: "ic_camera_close")
  internal static let icCameraFlashOff = ImageAsset(name: "ic_camera_flash_off")
  internal static let icCameraFlashOn = ImageAsset(name: "ic_camera_flash_on")
  internal static let icCameraFlipWhite = ImageAsset(name: "ic_camera_flip_white")
  internal static let icCameraTakeWhite = ImageAsset(name: "ic_camera_take_white")
  internal static let icClose = ImageAsset(name: "ic_close")
  internal static let icDrawer = ImageAsset(name: "ic_drawer")
  internal static let icHome = ImageAsset(name: "ic_home")
  internal static let icList = ImageAsset(name: "ic_list")
  internal static let icLogout = ImageAsset(name: "ic_logout")
  internal static let icPhoto = ImageAsset(name: "ic_photo")
  internal static let image1 = ImageAsset(name: "image1")
  internal static let image2 = ImageAsset(name: "image2")
  internal static let image3 = ImageAsset(name: "image3")
}
// swiftlint:enable identifier_name line_length nesting type_body_length type_name

// MARK: - Implementation Details

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
      fatalError("Unable to load image named \(name).")
    }
    return result
  }
}

internal extension ImageAsset.Image {
  @available(macOS, deprecated,
    message: "This initializer is unsafe on macOS, please use the ImageAsset.image property")
  convenience init!(asset: ImageAsset) {
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
