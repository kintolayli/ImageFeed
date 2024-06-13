//
//  OAuth2TokenStorage.swift
//  ImageFeed
//
//  Created by Ilya Lotnik on 12.06.2024.
//

import UIKit

final class OAuth2TokenStorage {
    var token: String? {
        get {
            return UserDefaults.standard.string(forKey: "bearerToken")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "bearerToken")
        }
    }
}
