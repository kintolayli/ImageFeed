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
            let isSuccess = KeychainWrapper.standard.set(newValue!, forKey: "bearerToken")
            guard isSuccess else {
                fatalError("Ошибка сохранения токена")
            }
        }
    }
    
    static func deleteToken() {
        let removeSuccessful: Bool = KeychainWrapper.standard.removeObject(forKey: "bearerToken")
        guard removeSuccessful else {
            fatalError("Ошибка удаления токена")
        }
    }
}
