//
//  OAuth2Service.swift
//  ImageFeed
//
//  Created by Ilya Lotnik on 12.06.2024.
//

import UIKit

enum AuthServiceError: Error {
    case invalidRequest
    case invalidResponse
    case invalidBaseUrl
    case invalidUrl
    case invalidCode
}

final class OAuth2Service {
    static let shared = OAuth2Service()
    let tokenStorage = OAuth2TokenStorage()
    
    private let urlSession = URLSession.shared
    
    private var task: URLSessionTask?
    private var lastCode: String?
    
    private init () {}
    
    func makeOAuthTokenRequest(code: String) throws ->  URLRequest? {
        guard var urlComponents = URLComponents(string: Constants.unsplashTokenURLString) else {
            throw AuthServiceError.invalidBaseUrl
        }
        
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: Constants.accessKey),
            URLQueryItem(name: "client_secret", value: Constants.secretKey),
            URLQueryItem(name: "redirect_uri", value: Constants.redirectURI),
            URLQueryItem(name: "code", value: code),
            URLQueryItem(name: "grant_type", value: "authorization_code")
        ]
        
        guard let url = urlComponents.url else {
            throw AuthServiceError.invalidUrl
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        return request
    }
    
    func fetchOAuthToken(code: String, completion: @escaping (Result<String, Error>) -> Void ) {
        assert(Thread.isMainThread)
        
        guard lastCode != code else {
            completion(.failure(AuthServiceError.invalidCode))
            return
        }
        
        task?.cancel()
        lastCode = code
        
        guard let request = try? makeOAuthTokenRequest(code: code) else {
            completion(.failure(AuthServiceError.invalidRequest))
            return
        }
        
        let task = urlSession.objectTask(for: request) { [weak self] (result: Result<OAuthTokenResponseBody, Error>) in
            switch result {
            case .success(let response):
                self?.tokenStorage.token = response.accessToken
                completion(.success(response.accessToken))
            case .failure(let error):
                print("[\(String(describing: self)).\(#function)]: \(AuthServiceError.invalidResponse) - Ошибка получения OAuth токена, \(error.localizedDescription)")
                completion(.failure(AuthServiceError.invalidResponse))
            }
            
            self?.task = nil
            self?.lastCode = nil
        }
        
        self.task = task
        task.resume()
    }
}
