//
//  Crypto.swift
//  iOStarter
//
//  Created by Crocodic-MBP5 on 17/03/21.
//  Copyright © 2021 WahyuAdyP. All rights reserved.
//

import Foundation
import CryptoSwift

private var key = "AES256Password"
private var iv = "AES256IV"

// All encrypt and decrypt is base64
extension String {
    // AES128: Key hash md5 -> 16 bytes
    // AES256: Key Hash sha256 -> 32 bytes
    /// Base64 encrypted value
    var encrypt: String? {
        do {
            guard let data = self.data(using: .utf8)?.bytes else { return nil }
            guard let keyHash = key.data(using: .utf8)?.bytes.sha256() else { return nil }
            guard let ivHash = iv.data(using: .utf8)?.bytes.md5() else { return nil }
            
            let aes = try AES(key: keyHash, blockMode: CBC(iv: ivHash))
            let chiper = try aes.encrypt(data)
            return chiper.toBase64()
        } catch let error {
            print("Error ecrypt: \(error.localizedDescription)")
            return nil
        }
    }
    
    /// Base64 decrypted value
    var decrypt: String? {
        do {
            guard let data = Data(base64Encoded: self)?.bytes else { return nil }
            guard let keyHash = key.data(using: .utf8)?.bytes.sha256() else { return nil }
            guard let ivHash = iv.data(using: .utf8)?.bytes.md5() else { return nil }
            
            let aes = try AES(key: keyHash, blockMode: CBC(iv: ivHash))
            let plain = try aes.decrypt(data)
            let plainData = Data(plain)
            return String(data: plainData, encoding: .utf8)!
        } catch let error {
            print("Error decrypt: \(error.localizedDescription), withValue: \(self)")
            return nil
        }
    }
}
