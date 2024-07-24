//
//  ProfileLogoutService.swift
//  ImageFeed
//
//  Created by Ilya Lotnik on 24.07.2024.
//

import Foundation
import WebKit


final class ProfileLogoutService {
    static let shared = ProfileLogoutService()
    
    private init() {}
    
    func logout() {
        OAuth2TokenStorage.deleteToken()
        cleanCookies()
        cleanProfile()
        cleanImageFeed()
    }
    
    private func cleanCookies() {
        HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)
        WKWebsiteDataStore.default().fetchDataRecords(
            ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
                records.forEach { record in
                    WKWebsiteDataStore.default().removeData(ofTypes: record.dataTypes, for: [record], completionHandler: {})
                }
            }
        
    }
    
    private func cleanProfile() {
        ProfileService.shared.clearProfile()
        ProfileImageService.shared.clearProfileImage()
    }
    
    private func cleanImageFeed() {
        ProfileImageService.shared.clearProfileImage()
    }
}
