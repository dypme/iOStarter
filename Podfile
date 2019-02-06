# Uncomment the next line to define a global platform for your project
platform :ios, '9.0'

def shared_pods

pod 'IQKeyboardManagerSwift', '~> 6.0'
pod 'Alamofire', '~> 4.7'
pod 'SwiftyJSON', '~> 4.0'
pod 'Kingfisher', '~> 4.0'
pod 'SwiftGen'
pod 'Firebase/Core'
pod 'Firebase/Messaging'
pod 'FirebaseInstanceID'
pod 'Fabric'
pod 'Crashlytics'

# Custom activity indicator. Change this if have more amazing custom activity indicator, delete/ leave it if no need custom activity indicator.
pod 'NVActivityIndicatorView', '~> 4.2.1'

# Uncomment realm swift if application need database then check DatabaseHelper class to use DatabaseHelper
#pod 'RealmSwift'

# Using for slider banner with more customization. Documentation: https://github.com/WenchaoD/FSPagerView
pod 'FSPagerView'

# Using for localization application. Documentation: https://github.com/Decybel07/L10n-swift
pod 'L10n-swift', '~> 5.4'

end

target 'iOS-Starter' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!
  shared_pods

  # Pods for iOS-Starter

  target 'iOS-StarterUITests' do
    inherit! :search_paths
    # Pods for testing
  end

end
