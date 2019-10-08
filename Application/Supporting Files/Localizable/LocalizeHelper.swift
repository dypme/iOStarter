//
//  LocalizableHelper.swift
//  iOS_Starter
//
//  Created by Crocodic MBP-2 on 14/08/18.
//  Copyright © 2018 Crocodic. All rights reserved.
//

import Foundation
import L10n_swift

class LocalizeHelper {
    static let shared = LocalizeHelper()
    
    enum SupportLanguage: String {
        case english = "en"
        case indonesian = "id"
    }
    
    /// Locale language code
    var language: SupportLanguage {
        get {
            if let lang = SupportLanguage(rawValue: L10n_swift.L10n.shared.language) {
                return lang
            }
            
            // Change to default language if apps not support device language
            return SupportLanguage.english
        }
        set (newValue) {
            let langIdentifier = newValue.rawValue
            UserDefaults.standard.set([newValue], forKey: "AppleLanguages")
            L10n_swift.L10n.shared.language = langIdentifier
        }
    }
    
    var locale: Locale {
        return Locale(identifier: language.rawValue)
    }
}
