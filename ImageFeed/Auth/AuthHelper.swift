//
//  AuthHelper.swift
//  ImageFeed
//
//  Created by Ilya Lotnik on 28.07.2024.
//

import Foundation


protocol AuthHelperProtocol {
    func authRequest() -> URLRequest?
    func code(from url: URL) -> String?
}


final class AuthHelper: AuthHelperProtocol {
    
    private let configuration: AuthConfiguration
    
    init(configuration: AuthConfiguration = .standard) {
        self.configuration = configuration
    }
    
    func authRequest() -> URLRequest? {
        let url = authUrl()
        
        return URLRequest(url: url)
    }
    
    func code(from url: URL) -> String? {
        if let urlComponents = URLComponents(string: url.absoluteString),
           urlComponents.path == "/oauth/authorize/native",
           let items = urlComponents.queryItems,
           let codeItem = items.first(where: { $0.name == "code" })
        {
            return codeItem.value
        } else {
            return nil
        }
    }
    
    func authUrl() -> URL {
        guard var urlComponents = URLComponents(string: configuration.authURLString) else {
            fatalError("[\(String(describing: AuthHelper.self)).\(#function)]: Error when initialize URLComponents")
        }
        
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: configuration.accessKey),
            URLQueryItem(name: "redirect_uri", value: configuration.redirectURI),
            URLQueryItem(name: "response_type", value: "code"),
            URLQueryItem(name: "scope", value: configuration.accessScope),
        ]
        
        guard let url = urlComponents.url else {
            fatalError("[\(String(describing: AuthHelper.self)).\(#function)]: Error when initialize URLComponents.url")
        }
        return url
    }
}
