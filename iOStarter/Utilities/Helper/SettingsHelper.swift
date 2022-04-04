//
//  SettingsHelper.swift
//  iOStarter
//
//  Created by Crocodic-MBP5 on 28/01/20.
//  Copyright © 2020 WahyuAdyP. All rights reserved.
//

import Foundation
import Kingfisher
//import RealmSwift

class SettingsHelper {
    private struct SettingsBundleKeys {
        static let fullVersionKey = "settings_full_version"
        static let copyrightKey = "settings_copyright"
        static let clearDataKey = "settings_clear_data"
        static let clearCacheKey = "settings_clear_cache"
    }
    
    static func setupSettings() {
        clearData()
        clearCache(isForce: false)
        setSettingsInformation()
    }
    
    private class func clearData() {
        if UserDefaults.standard.bool(forKey: SettingsBundleKeys.clearDataKey) {
            UserDefaults.standard.set(false, forKey: SettingsBundleKeys.clearDataKey)
            
            clearCache(isForce: true)
            UserSession.shared.clearData()
//            DatabaseHelper.shared.deleteAllData()
        }
    }
    
    private class func clearCache(isForce: Bool) {
        if UserDefaults.standard.bool(forKey: SettingsBundleKeys.clearCacheKey) || isForce {
            UserDefaults.standard.set(false, forKey: SettingsBundleKeys.clearCacheKey)
            
            HTTPCookieStorage.shared.cookies?.forEach({ (cookie) in
                HTTPCookieStorage.shared.deleteCookie(cookie)
            })
            URLCache.shared.removeAllCachedResponses()
            URLCache.shared.diskCapacity = 0
            URLCache.shared.memoryCapacity = 0
            
            ImageCache.default.clearMemoryCache()
            ImageCache.default.clearDiskCache()
        }
    }
    
    private class func setSettingsInformation() {
        var fullVersions = [String]()
        if let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String {
            fullVersions.append(version)
        }
        if let build = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String {
            if fullVersions.isEmpty {
                fullVersions.append(build)
            } else {
                fullVersions.append("(\(build)")
            }
        }
        UserDefaults.standard.set(fullVersions.joined(separator: " "), forKey: SettingsBundleKeys.fullVersionKey)
    }
}
