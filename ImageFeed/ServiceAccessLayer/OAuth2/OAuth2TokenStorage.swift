//
//  OAuth2TokenStorage.swift
//  ImageFeed
//
//  Created by Ilya Lotnik on 12.06.2024.
//

import UIKit
import SwiftKeychainWrapper


final class OAuth2TokenStorage {
    
    var token: String? {
        get {
            KeychainWrapper.standard.string(forKey: "bearerToken")
        }
        set {
            if let newValue = newValue {
                KeychainWrapper.standard.set(newValue, forKey: "bearerToken")
            }
        }
    }
    
    static func deleteToken() {
        KeychainWrapper.standard.removeObject(forKey: "bearerToken")
    }
}
