//
//  SettingsBundleHelper.swift
//  AngkasaPuraTL
//
//  Created by Crocodic-MBP5 on 28/01/20.
//  Copyright © 2020 Crocodic Studio. All rights reserved.
//

import Foundation
import Kingfisher
//import RealmSwift

class SettingsBundleHelper {
    private struct SettingsBundleKeys {
        static let fullVersionKey = "settings_full_version"
        static let copyrightKey = "settings_copyright"
        static let clearDataKey = "settings_clear_data"
        static let clearCacheKey = "settings_clear_cache"
    }
    
    class func setupSettings() {
        clearData()
        clearCache(isForce: false)
        setSettingsInformation()
    }
    
    private class func clearData() {
        if UserDefaults.standard.bool(forKey: SettingsBundleKeys.clearDataKey) {
            UserDefaults.standard.set(false, forKey: SettingsBundleKeys.clearDataKey)
            
            UserSession.shared.clearData()
            clearCache(isForce: true)
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
        let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "-"
        let build = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String ?? "-"
        
        UserDefaults.standard.set(version + " (" + build + ")", forKey: SettingsBundleKeys.fullVersionKey)
    }
}
