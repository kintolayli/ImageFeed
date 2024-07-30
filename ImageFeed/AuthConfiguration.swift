//
//  Constants.swift
//  ImageFeed
//
//  Created by Ilya Lotnik on 04.06.2024.
//

import Foundation

enum Constants {
    static let accessKey = "vduxIzYPQCaGVtwf1eoMIVA9HfZFKyBsQqNo7Z2rVdk"
    static let secretKey = "RR0pTZQi8-zx7bhNYhec8Zpn2lwwyabXKo-R9YWrrI8"
    static let redirectURI = "urn:ietf:wg:oauth:2.0:oob"
    static let accessScope = "public+read_user+write_likes"
    static let defaultBaseUrl = URL(string: defaultBaseUrlString)
    static let defaultBaseUrlString = "https://api.unsplash.com"
    static let unsplashAuthorizeURLString = "https://unsplash.com/oauth/authorize"
    static let unsplashTokenURLString = "https://unsplash.com/oauth/token"
    static let unsplashAuthorizeNativeURLString = "/oauth/authorize/native"
}

struct AuthConfiguration {
    let accessKey: String
    let secretKey: String
    let redirectURI: String
    let accessScope: String
    let defaultBaseUrl: URL
    let authURLString: String
    
    static var standard: AuthConfiguration = {
        guard let baseUrl = Constants.defaultBaseUrl else {
            fatalError("[\(String(describing: AuthConfiguration.self)).\(#function)]: DefaultBaseUrl is nil")
        }
        
        return AuthConfiguration(
            accessKey: Constants.accessKey,
            secretKey: Constants.secretKey,
            redirectURI: Constants.redirectURI,
            accessScope: Constants.accessScope,
            defaultBaseUrl: baseUrl,
            authURLString: Constants.unsplashAuthorizeURLString
        )
    }()
    
    init(accessKey: String, secretKey: String, redirectURI: String, accessScope: String, defaultBaseUrl: URL, authURLString: String) {
        self.accessKey = accessKey
        self.secretKey = secretKey
        self.redirectURI = redirectURI
        self.accessScope = accessScope
        self.defaultBaseUrl = defaultBaseUrl
        self.authURLString = authURLString
    }
}
