//
//  OAuth2TokenStorage.swift
//  ImageFeed
//
//  Created by Ilya Lotnik on 12.06.2024.
//

import UIKit
import SwiftKeychainWrapper

//final class OAuth2TokenStorage {
//    var token: String? {
//        get {
//            return UserDefaults.standard.string(forKey: "bearerToken")
//        }
//        set {
//            UserDefaults.standard.set(newValue, forKey: "bearerToken")
//        }
//    }
//}

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
}
