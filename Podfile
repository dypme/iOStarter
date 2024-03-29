# Uncomment the next line to define a global platform for your project
platform :ios, '14.0'

def shared_pods
    
    # Keyboard helper. Source: https://github.com/hackiftekhar/IQKeyboardManager
    pod 'IQKeyboardManagerSwift'
    
    # HTTP networking. Source: https://github.com/Alamofire/Alamofire
    pod 'Alamofire'
    
    # Simple JSON parser. Source: https://github.com/SwiftyJSON/SwiftyJSON
    pod 'SwiftyJSON'
    
    # Image downloading/ caching. Source: https://github.com/onevcat/Kingfisher
    pod 'Kingfisher'
    
    # Asset tool generator to swift file. Source: https://github.com/SwiftGen/SwiftGen
    pod 'SwiftGen'
    # A Swift mixin. Source: https://github.com/AliSoftware/Reusable
    pod 'Reusable'
    
    pod 'Firebase/Messaging'
    pod 'Firebase/Crashlytics'
    pod 'Firebase/Performance'
    pod 'Firebase/Analytics'
    
    # A license list generator of all your dependencies for iOS applications. Source: https://github.com/mono0926/LicensePlist
    pod 'LicensePlist'
    
    # Custom activity indicator. Change this if have more amazing custom activity indicator, delete/ leave it if no need custom activity indicator. Source: https://github.com/ninjaprox/NVActivityIndicatorView
    pod 'NVActivityIndicatorView'
    
    # Crypto related functions and helpers for Swift implemented in Swift. (#PureSwift). Source: https://github.com/krzyzanowskim/CryptoSwift
    pod 'CryptoSwift'
    
    # Uncomment realm swift if application need database then check DatabaseHelper class to use DatabaseHelper
#    pod 'RealmSwift'
    
    # MMKV is an efficient, small, easy-to-use mobile key-value storage framework. Source: https://github.com/Tencent/MMKV
    pod 'MMKV'
    
    # Using for localization application. Source: https://github.com/Decybel07/L10n-swift
    pod 'L10n-swift'
    
    # Image/ video preview. Original source: https://github.com/hyperoslo/Lightbox
    pod 'Lightbox', :git => 'https://github.com/dypme/Lightbox.git'
    
    # A Protocol-Oriented NotificationCenter which is type safe, thread safe and with memory safety.. Source: https://github.com/100mango/SwiftNotificationCenter
    pod 'SwiftNotificationCenter'
    
    # A UITextView subclass that adds support for multiline placeholder written in Swift. Source: https://github.com/MoZhouqi/KMPlaceholderTextView
    pod 'KMPlaceholderTextView'
    
    pod 'MaterialComponents/TextControls+FilledTextAreas'
    pod 'MaterialComponents/TextControls+FilledTextFields'
    pod 'MaterialComponents/TextControls+OutlinedTextAreas'
    pod 'MaterialComponents/TextControls+OutlinedTextFields'
    
end

target 'iOStarter' do
    # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
    use_frameworks!
    shared_pods
    
    # Pods for iOS_Starter
    
end

post_install do |installer|
   installer.pods_project.targets.each do |target|
     target.build_configurations.each do |config|
       config.build_settings['EXPANDED_CODE_SIGN_IDENTITY'] = ""
       config.build_settings['CODE_SIGNING_REQUIRED'] = "NO"
       config.build_settings['CODE_SIGNING_ALLOWED'] = "NO"
      end
   end
 end
