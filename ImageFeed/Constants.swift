//
//  Constants.swift
//  ImageFeed
//
//  Created by Ilya Lotnik on 04.06.2024.
//

import Foundation

public enum Constants {
    static let accessKey = "vduxIzYPQCaGVtwf1eoMIVA9HfZFKyBsQqNo7Z2rVdk"
    static let secretKey = "RR0pTZQi8-zx7bhNYhec8Zpn2lwwyabXKo-R9YWrrI8"
    static let redirectURI = "urn:ietf:wg:oauth:2.0:oob"
    static let accessScope = "public+read_user+write_likes"
    static let defaultBaseUrl = URL(string: "https://api.unsplash.com/")
    static let unsplashAuthorizeURLString = "https://unsplash.com/oauth/authorize"
    static let unsplashTokenURLString = "https://unsplash.com/oauth/token"
    static let unsplashAuthorizeNativeURLString = "/oauth/authorize/native"
}
