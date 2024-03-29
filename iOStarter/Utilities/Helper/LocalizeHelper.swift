//
//  LocalizeHelper.swift
//  iOStarter
//
//  Created by Macintosh on 07/04/22.
//  
//
//  This file was generated by Project Xcode Templates
//  Created by Wahyu Ady Prasetyo,
//  Source: https://github.com/dypme/iOStarter
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
        set {
            let langIdentifier = newValue.rawValue
            L10n_swift.L10n.shared.language = langIdentifier
        }
    }
    
    var locale: Locale {
        return Locale(identifier: language.rawValue)
    }
}
